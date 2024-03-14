`timescale 1 ns / 1 ps
`default_nettype wire
`define MAX2(v1, v2) ((v1) > (v2) ? (v1) : (v2))

module mpsoc_preset_wrapper #(    
    parameter NUM_CHAINS = 4, // Four pipes
    parameter NUM_CHIPS_PER_CHAIN = 2 // Two address lines
) (
    input wire CLK_125_P, CLK_125_N,
	input wire [3:0] switches,
	output wire [3:0] leds,

	output wire ROSC_EN,
	output wire WEIGHT_EN,
	output wire SCANOUT_CLK,
	output wire SAMPLE_CLK,

	output wire [5:0] ROW_ADDR,
	output wire [5:0] COL_ADDR,

	output wire ADDR_EN_ROW1,
	output wire ADDR_EN_ROW2,
	
	output wire [5:0] WEIGHT_PIPE1,
	output wire [5:0] WEIGHT_PIPE2,
	output wire [5:0] WEIGHT_PIPE3,
	output wire [5:0] WEIGHT_PIPE4,

	output wire SCAN_CHAIN_IN,

	input  wire SCAN_CHAIN_OUT_PIPE1,
	input  wire SCAN_CHAIN_OUT_PIPE2,
	input  wire SCAN_CHAIN_OUT_PIPE3,
	input  wire SCAN_CHAIN_OUT_PIPE4
);

localparam SCAN_CHAIN_DEPTH = 504 * NUM_CHIPS_PER_CHAIN;
localparam CHIP_ADDR_WIDTH = `MAX2($clog2(NUM_CHIPS_PER_CHAIN), 1);

wire pl_clk0;

wire [31:0] bram0_addr, bram0_din;
wire [3:0] bram0_we;

wire [31:0] bram1_addr, bram1_dout;

wire [31:0] input_flags, output_flags;

wire clk125, clk125_b4buf;
IBUFDS bufds_clk125 (.I(CLK_125_P), .IB(CLK_125_N), .O(clk125_b4buf));
BUFG   bufg_clk125  (.I(clk125_b4buf), .O(clk125));

mpsoc_preset mpsoc_preset_i(
	.bram0_addr(bram0_addr),
	.bram0_clk(pl_clk0),
	.bram0_din(bram0_din),
	.bram0_dout(),
	.bram0_en(1'b1),
	.bram0_rst(1'b0),
	.bram0_we(bram0_we),

	.bram1_addr(bram1_addr),
	.bram1_clk(pl_clk0),
	.bram1_din(),
	.bram1_dout(bram1_dout),
	.bram1_en(1'b1),
	.bram1_rst(1'b0),
	.bram1_we(4'b0),

	.input_flags(input_flags),
	.output_flags(output_flags),

	.pl_clk0(pl_clk0)
);

assign ROSC_EN = 1'b1;

// Scan chain is write-only
wire scan_chain_out_valid;

assign bram0_din = {28'b0, SCAN_CHAIN_OUT_PIPE4, SCAN_CHAIN_OUT_PIPE3, SCAN_CHAIN_OUT_PIPE2, SCAN_CHAIN_OUT_PIPE1};
assign bram0_addr[31:$clog2(SCAN_CHAIN_DEPTH)+2] = 0;
assign bram0_addr[1:0] = 0;
scan_chain #(SCAN_CHAIN_DEPTH) scan_chain_i (
	.clk(pl_clk0),

	.start(output_flags[0]),
	.ready(input_flags[0]),

	.scanout_clk(SCANOUT_CLK),
	.sample_clk(SAMPLE_CLK),
	.scan_chain_out_valid(scan_chain_out_valid),
	.bit_addr(bram0_addr[$clog2(SCAN_CHAIN_DEPTH)-1+2:2])
);

assign bram0_we = {4{scan_chain_out_valid}};

// Programming BRAM is read-only
wire [CHIP_ADDR_WIDTH-1:0] chip_in_chain_addr;
wire [1:0] addr_en;

assign bram1_addr = {{(32-12-CHIP_ADDR_WIDTH)-2{1'b0}}, chip_in_chain_addr, ROW_ADDR, COL_ADDR, 2'b0};
programming #(NUM_CHIPS_PER_CHAIN) programming_i (
	.clk(pl_clk0),
	.start(output_flags[1]),
	.ready(input_flags[1]),
	.row_addr(ROW_ADDR),
	.col_addr(COL_ADDR),
	.chip_in_chain_addr(chip_in_chain_addr),
	.addr_en(addr_en)
);

assign WEIGHT_PIPE1 = bram1_dout[5:0];
assign WEIGHT_PIPE2 = bram1_dout[11:6];
assign WEIGHT_PIPE3 = bram1_dout[17:12];
assign WEIGHT_PIPE4 = bram1_dout[23:18];

assign ADDR_EN_ROW2 = addr_en[1];
assign ADDR_EN_ROW1 = addr_en[0];

// CPU controlled IO
assign SCAN_CHAIN_IN = output_flags[2];
assign WEIGHT_EN = output_flags[3];

// Clock function verify LED
reg [31:0] count = 0;
always @ (posedge pl_clk0) begin
    count <= count + 1;
end

assign leds = {count[27], ADDR_EN_ROW1, SCAN_CHAIN_OUT_PIPE1, count[26]};

endmodule
