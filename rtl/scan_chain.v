`timescale 1ns / 1ns
`default_nettype none

module scan_chain #(
	parameter SCAN_CHAIN_DEPTH = 504
) (
	input  wire clk,

	input  wire start,
	output reg  ready = 1,

	output reg  scanout_clk = 0,
	output reg  sample_clk = 0,
	output reg  scan_chain_out_valid  = 0,
	output reg  [SCAN_CHAIN_DEPTH_BITS-1:0] bit_addr = 0
);

localparam SCAN_CHAIN_DEPTH_BITS = $clog2(SCAN_CHAIN_DEPTH);

localparam S_IDLE = 0;
localparam S_POS_SAMPLE = 1;
localparam S_NEG_SAMPLE = 2;
localparam S_POS_CLOCK = 3;
localparam S_READ_BIT = 4;
localparam S_NEG_CLOCK = 5;
reg [6:0] state = S_IDLE;

// Adjust to slow down output/align it
localparam POS_SAMPLE_EXTRA_CLOCKS = 10;
localparam NEG_SAMPLE_EXTRA_CLOCKS = 10;
localparam POS_CLOCK_EXTRA_CLOCKS = 3;
localparam NEG_CLOCK_EXTRA_CLOCKS = 5;
reg [20:0] clk_count = 0;

always @ (posedge clk) begin
	if (start) begin
		ready <= 0;
		scanout_clk <= 0;
		sample_clk <= 0;
		bit_addr <= {SCAN_CHAIN_DEPTH_BITS{1'b1}};
		clk_count <= 0;

		state <= S_POS_SAMPLE;
	end else begin
		clk_count <= clk_count + 1;
		case (state)
			// Start sample
			S_POS_SAMPLE : begin
				sample_clk <= 1;
				if (clk_count == POS_SAMPLE_EXTRA_CLOCKS) begin
					clk_count <= 0;
					state <= S_NEG_SAMPLE;
				end
			end
			// Wait until reading data
			S_NEG_SAMPLE : begin
				sample_clk <= 0;
				if (clk_count == NEG_SAMPLE_EXTRA_CLOCKS) begin
					clk_count <= 0;
					state <= S_READ_BIT; // First bit is unclocked
				end
			end

			/* Loop over SCAN_CHAIN_DEPTH number of bits */
			// Rising edge of clock
			S_POS_CLOCK : begin
				scanout_clk <= 1;
				if (clk_count == POS_CLOCK_EXTRA_CLOCKS) begin
					clk_count <= 0;
					state <= S_READ_BIT;
				end
			end
			// Read bit from scanchain
			S_READ_BIT : begin
				scan_chain_out_valid <= 1;
				bit_addr <= bit_addr + 1;
				state <= S_NEG_CLOCK;
			end
			// Falling edge of clock
			S_NEG_CLOCK : begin
				scan_chain_out_valid <= 0;
				scanout_clk <= 0;

				if (bit_addr == SCAN_CHAIN_DEPTH - 1) begin
					ready <= 1;
					state <= S_IDLE;
				end else if (clk_count == NEG_CLOCK_EXTRA_CLOCKS) begin
					clk_count <= 0;
					state <= S_POS_CLOCK;
				end
			end
		endcase
	end
end

endmodule
