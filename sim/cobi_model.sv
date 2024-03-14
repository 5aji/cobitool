`default_nettype none
module cobi_model (
	input wire [5:0] i_ROW_ADDR,
	input wire [5:0] i_COL_ADDR,
	input wire [5:0] i_WEIGHT,
	input wire i_ADDR_EN64,
	input wire i_WEIGHT_EN,
	input wire i_ROSC_EN,

	output wire o_SCANOUT_DOUT64,
	input wire i_SCANOUT_CLK,
	input wire i_ALL_ROW_HI,
	input wire i_SAMPLE_CLK);

	// Store weights in RAM block
	reg [5:0] weights [0:4095];
	/*initial begin
		for (i = 0; i < 4096; i = i + 1) begin
			weights[i] = i[5:0];
		end
	end*/

	always_latch begin
		if (i_ADDR_EN64)
			weights[{i_ROW_ADDR, i_COL_ADDR}] = i_WEIGHT;
	end

	reg [503:0] scanchain;

	assign o_SCANOUT_DOUT64 = scanchain[0];

	integer i;
	always @ (posedge i_SCANOUT_CLK, posedge i_SAMPLE_CLK) begin
		if (i_SAMPLE_CLK) begin
			if (i_ROSC_EN) begin
				// Dummy sample to indicate successful operation
				for (i = 0; i < 504; i = i + 1) begin
					scanchain[i] <= weights[i][0];
				end
			end else begin
				scanchain <= 504'hX;
			end
		end else begin
			// Shift scanchain
			scanchain <= {i_ALL_ROW_HI, scanchain[503:1]};
		end
	end
endmodule
