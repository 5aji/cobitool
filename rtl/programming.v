`timescale 1ns / 1ns
`default_nettype none
`define MAX2(v1, v2) ((v1) > (v2) ? (v1) : (v2))

module programming #(
	parameter NUM_CHIPS_PER_CHAIN = 1
) (
	input  wire clk,
	input  wire start,
	output reg  ready = 1,

	output wire [5:0] row_addr,
	output wire [5:0] col_addr,
	output wire [CHIP_ADDR_WIDTH-1:0] chip_in_chain_addr, // Binary
	output wire [NUM_CHIPS_PER_CHAIN-1:0] addr_en // One hot
);

localparam CHIP_ADDR_WIDTH = `MAX2($clog2(NUM_CHIPS_PER_CHAIN), 1);

localparam S_IDLE = 0;
localparam S_POS_ADDR_EN = 1;
localparam S_NEG_ADDR_EN = 2;
localparam S_INC_ADDR = 3;
reg [1:0] state = S_IDLE;

// Adjust to slow down stages/adjust waveform
localparam POS_ADDR_EN_EXTRA_CLOCKS = 5;
localparam NEG_ADDR_EN_EXTRA_CLOCKS = 4;
reg [6:0] clk_count;

reg [11+CHIP_ADDR_WIDTH:0] addr = 0;
reg addr_gate = 0;

always @ (posedge clk) begin
	if (start) begin
		ready <= 0;
		addr_gate <= 0;
		addr <= 0;
		clk_count <= 0;

		state <= S_POS_ADDR_EN;
	end else begin
		clk_count <= clk_count + 1;
		case (state)
			// Write data to COBI chip
			S_POS_ADDR_EN : begin
				addr_gate <= 1;
				if (clk_count == POS_ADDR_EN_EXTRA_CLOCKS) begin
					clk_count <= 0;
					state <= S_NEG_ADDR_EN;
				end
			end
			// Stop writing
			S_NEG_ADDR_EN : begin
				addr_gate <= 0;
				if (clk_count == NEG_ADDR_EN_EXTRA_CLOCKS) begin
					clk_count <= 0;
					state <= S_INC_ADDR;
				end
			end
			// Increment address with data addr_en disabled
			S_INC_ADDR : begin
				addr <= addr + 1;
				if (addr[11:0] == 12'hFFF && addr[12+CHIP_ADDR_WIDTH-1:12] == NUM_CHIPS_PER_CHAIN-1) begin
					ready <= 1;
					state <= S_IDLE;
				end else begin
					clk_count <= 0;
					state <= S_POS_ADDR_EN;
				end
			end
		endcase
	end
end

assign col_addr = addr[5:0];
assign row_addr = addr[11:6];
assign chip_in_chain_addr = addr[12+CHIP_ADDR_WIDTH-1:12];
assign addr_en = (addr_gate << chip_in_chain_addr);

endmodule
