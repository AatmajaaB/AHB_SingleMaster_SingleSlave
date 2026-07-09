//--------------------------------------------------
//Testbench
//--------------------------------------------------
`timescale 1ns/1ns
module one_master_slave_tb();
  reg hclk;
  reg hresetn;
  reg enable;
  reg [31:0] dina;
  reg [31:0] dinb;
  reg [31:0] addr;
  reg wr;
  reg [1:0] slave_sel;
  wire [31:0] dout;
  //----------------------------------------------------------------------
  //Initialization of signals
  //----------------------------------------------------------------------
  initial begin
    hclk = 0;
    hresetn = 1;
    enable = 1'b0;
    dina = 32'd0;
    dinb = 32'd0;
    addr = 32'd0;
    wr = 1'b0;
    slave_sel = 2'b00;
    #10 hresetn = 0;
    #10 hresetn = 1;
    //----------------------------------------------------------------------
    //Calling Write task
    //----------------------------------------------------------------------
    write(32'hAB511234,32'h12345678,32'd1);
    //----------------------------------------------------------------------
    //Calling Read task
    //----------------------------------------------------------------------
    read(32'hAB511234);
  end
  //----------------------------------------------------------------------
  //Write task
  //----------------------------------------------------------------------
  task write( input [31:0] address, input [31:0] a, input [31:0] b);
    begin
      @(posedge hclk)
      slave_sel[0] = 1'b1;
      enable = 1'b1;
      addr = address;
      @(posedge hclk)
      dina = a;
      dinb = b;
      wr = 1'b1;
      @(posedge hclk)
      enable = 1'b0;
      slave_sel[0] = 1'b0;
    end
  endtask
  //----------------------------------------------------------------------
  //Read task
  //----------------------------------------------------------------------
  task read(input [31:0] address);
    begin
      @(posedge hclk)
      enable = 1'b1;
      slave_sel[0] = 1'b1;
      addr = address;
      @(posedge hclk)
      wr = 1'b0;
      // two beats for read
      @(posedge hclk)
      wr = 1'b0;
      @(posedge hclk)
      wr = 1'b0;
      @(posedge hclk)
      enable = 1'b0;
      slave_sel[0] = 1'b0;
    end
    endtask
  //----------------------------------------------------------------------
  //Instantiation of the top module
  //----------------------------------------------------------------------
  one_master_slave dut(
    .hclk(hclk),
    .hresetn(hresetn),
    .enable(enable),
    .dina(dina),
    .dinb(dinb),
    .addr(addr),
    .wr(wr),
    .slave_sel(slave_sel),
    .dout(dout)
  );
  //----------------------------------------------------------------------
  //Clock generation
  //----------------------------------------------------------------------
  always #2 hclk <= ~hclk;
  //----------------------------------------------------------------------
  //Waveform generation
  //----------------------------------------------------------------------
  initial 
    begin
      $dumpfile("wave.vcd");
      $dumpvars();
    end
  //----------------------------------------------------------------------
  //Monitor statement, to get display of output
  //----------------------------------------------------------------------
  initial
    begin
      $monitor("HCLK = %b, HRESETn = %b, enable = %b, wr = %b, Address = %b, Din_a = %b, Din_b = %b, Dout = %b", hclk, hresetn, enable, wr, addr, dina, dinb, dout);
    end
  initial 
    begin
      #100;
      $finish;
    end
endmodule