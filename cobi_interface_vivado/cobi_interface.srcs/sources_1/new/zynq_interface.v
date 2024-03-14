`timescale 1ns / 1ps

module zynq_interface(
    // Clock
    input  wire clk,

    // AXI GPIO
    output wire [31:0] input_flags,
    input  wire [31:0] output_flags,
    
    // AXI BRAM 1
    output wire [31:0] bram0_addr,
    output wire bram0_clk,
    output reg  [31:0] bram0_din,
    input  wire [31:0] bram0_dout,
    output reg  bram0_en,
    output wire bram0_rst,
    output reg  [3:0] bram0_we,
    
    // AXI BRAM 2
    output wire [31:0] bram1_addr,
    output wire bram1_clk,
    output reg  [31:0] bram1_din,
    input  wire [31:0] bram1_dout,
    output reg  bram1_en,
    output wire bram1_rst,
    output reg  [3:0] bram1_we,
    
    // LEDs
    output wire [3:0] leds,
    
    // Switches
    input wire [3:0] switches);
    
    // Setup BRAM interface
    reg [15:0] address;
    assign bram0_addr = {16'b0, address};
    assign bram1_addr = {16'b0, address};
    assign bram0_clk = clk;
    assign bram1_clk = clk;
    assign bram0_rst = 1'b0;
    assign bram1_rst = 1'b0;
        
    // Loopback some input flags and switches
    assign input_flags = {output_flags[31:4], switches};
    // Display one switch and 3 input flags on LEDs
    assign leds = {output_flags[3:2], switches[1], output_flags[0]};
    
    always @ (posedge clk) begin
        if (output_flags[0]) begin
            address <= address + 16'h1;
            bram0_en <= 1'b1;
            bram1_en <= 1'b1;
            // Copy from one to other with direction based on output_flag[1]
            if (output_flags[1]) begin
                bram0_we <= 4'b1111;
                bram1_we <= 4'b0000;
                bram0_din <= bram1_dout;
                bram1_din <= 16'h0000;
            end else begin
                bram0_we <= 4'b0000;
                bram1_we <= 4'b1111;
                bram0_din <= 16'h0000;
                bram1_din <= bram0_dout;
            end
        end else begin
            bram0_en <= 1'b0;
            bram1_en <= 1'b0;
            bram0_we <= 4'b0000;
            bram1_we <= 4'b0000;
            address <= 16'h0000;
            bram0_din <= 32'h0;
            bram1_din <= 32'h0;
        end
    end
    
endmodule
