`timescale 1ns / 1ns
`default_nettype none
`define MAX2(v1, v2) ((v1) > (v2) ? (v1) : (v2))

module cobi_interface_tb #(
	parameter NUM_CHAINS = 4,
	parameter NUM_CHIPS_PER_CHAIN = 2
) (
	output reg  clk = 0,
	output reg  start_prog = 0,
	output reg  start_scan = 0,

	output wire scanout_clk,
	output wire sample_clk,
	output wire ready_prog,
	output wire ready_scan,
	output wire [$clog2(SCAN_CHAIN_DEPTH)-1:0] bit_addr,
	output wire scan_chain_out_valid,
	output wire [NUM_CHIPS_PER_CHAIN-1:0] addr_en,
	output reg  weight_en,
	output reg  all_row_hi
);

localparam SCAN_CHAIN_DEPTH = 504 * NUM_CHIPS_PER_CHAIN;
localparam CHIP_ADDR_WIDTH = `MAX2($clog2(NUM_CHIPS_PER_CHAIN), 1);

wire [5:0] row_addr;
wire [5:0] col_addr;
wire [CHIP_ADDR_WIDTH-1:0] chip_in_chain_addr;

// Write-only BRAM model for scanchain
wire [NUM_CHAINS-1:0] scanout_data;
reg [NUM_CHAINS-1:0] scanchain_data [0:SCAN_CHAIN_DEPTH-1];
always @ (posedge clk) begin
	if (scan_chain_out_valid) // WE
		scanchain_data[bit_addr] <= scanout_data;
end

// Read-only BRAM model for programming
reg [6*NUM_CHAINS-1:0] weights;
reg [6*NUM_CHAINS-1:0] programming_data [0:$pow(2, 12 + CHIP_ADDR_WIDTH)-1];
initial $readmemh("rand_weights.hex", programming_data);
always @ (posedge clk) begin
	weights <= programming_data[{chip_in_chain_addr, row_addr, col_addr}];
end

scan_chain #(SCAN_CHAIN_DEPTH) scan_chain_i (
	.clk(clk),
	.start(start_scan),
	.ready(ready_scan),
	.scanout_clk(scanout_clk),
	.sample_clk(sample_clk),
	.scan_chain_out_valid(scan_chain_out_valid),
	.bit_addr(bit_addr)
);

programming #(NUM_CHIPS_PER_CHAIN) programming_i (
	.clk(clk),
	.start(start_prog),
	.ready(ready_prog),
	.row_addr(row_addr),
	.col_addr(col_addr),
	.chip_in_chain_addr(chip_in_chain_addr),
	.addr_en(addr_en)
);

// COBI models to test against
cobi_network #(NUM_CHAINS, NUM_CHIPS_PER_CHAIN) cobi_network_inst (
	.i_ROW_ADDR(row_addr),
	.i_COL_ADDR(col_addr),
	.i_WEIGHT(weights),
	.i_ADDR_EN64(addr_en),
	.i_WEIGHT_EN(weight_en),
	.i_SCANOUT_CLK(scanout_clk),
	.i_SAMPLE_CLK(sample_clk),
	.i_ALL_ROW_HI(all_row_hi),
	.i_ROSC_EN(1'b1),
	.o_SCANOUT_DOUT64(scanout_data)
);

always #1 clk = !clk;

initial begin
	$dumpfile("dump.vcd");
	$dumpvars();

	// Zero values
	weight_en = 1;
	start_prog = 0;
	start_scan = 0;
	all_row_hi = 0;

	/* Programming (BRAM with programming data should be written by now) */
	#100;
	start_prog = 1;
	#100;
	start_prog = 0;

	wait (ready_prog == 1);

	/* Scanchain readout */
	all_row_hi = 1;
	// Randomize spins (will probably move into scanchain logic)
	weight_en = 0;
	#10;
	weight_en = 1;

	#100;
	start_scan = 1;
	#100;
	start_scan = 0;

	wait (ready_scan == 1);
	#10;
	all_row_hi = 0;
	#100;

	// Can read scanchain results from BRAM now
	$writememh("dump.hex", scanchain_data);
	$finish();
end

endmodule
