`default_nettype none
module cobi_network #(parameter NUM_CHAINS=4, parameter NUM_CHIPS_PER_CHAIN=1) (
	input wire [5:0] i_ROW_ADDR,
	input wire [5:0] i_COL_ADDR,

	input wire [6*NUM_CHAINS-1:0] i_WEIGHT,
	input wire [NUM_CHIPS_PER_CHAIN-1:0] i_ADDR_EN64,
	input wire i_WEIGHT_EN,
	input wire i_ROSC_EN,

	output wire [NUM_CHAINS-1:0] o_SCANOUT_DOUT64,
	input wire  i_SCANOUT_CLK,
	input wire  i_ALL_ROW_HI,
	input wire  i_SAMPLE_CLK);

	wire chains[NUM_CHAINS*(NUM_CHIPS_PER_CHAIN+1)-1:0];

	genvar i, j;
	generate
		for (i = 0; i < NUM_CHAINS; i = i + 1) begin
			assign chains[i*(NUM_CHIPS_PER_CHAIN+1)] = i_ALL_ROW_HI;
			assign o_SCANOUT_DOUT64[i] = chains[(i+1)*(NUM_CHIPS_PER_CHAIN+1)-1];
			for (j = 0; j < NUM_CHIPS_PER_CHAIN; j = j + 1) begin
				cobi_model i0 (
					.i_ROW_ADDR(i_ROW_ADDR),
					.i_COL_ADDR(i_COL_ADDR),
					.i_WEIGHT(i_WEIGHT[6*(i+1)-1:6*i]),
					.i_ADDR_EN64(i_ADDR_EN64[j]),
					.i_WEIGHT_EN(i_WEIGHT_EN),
					.i_ROSC_EN(i_ROSC_EN),
					.o_SCANOUT_DOUT64(chains[i*(NUM_CHIPS_PER_CHAIN+1)+j+1]),
					.i_SCANOUT_CLK(i_SCANOUT_CLK),
					.i_ALL_ROW_HI(chains[i*(NUM_CHIPS_PER_CHAIN+1)+j]),
					.i_SAMPLE_CLK(i_SAMPLE_CLK)
				);
			end
		end
	endgenerate

endmodule
