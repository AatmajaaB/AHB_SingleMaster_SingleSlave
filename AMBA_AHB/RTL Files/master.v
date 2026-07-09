module ahb_master(
  //----------------------------------------------------
  // Input pins
  //----------------------------------------------------
  input hclk,
  input hresetn,
  input enable,
  input [31:0] dina,
  input [31:0] dinb,
  input [31:0] addr,
  input wr,
  input hreadyout,
  input hresp,
  input [31:0] hrdata,
  input [1:0] slave_sel,
  //----------------------------------------------------
  // Output pins
  //----------------------------------------------------
  output reg [1:0] sel,
  output reg [31:0] haddr,
  output reg hwrite,
  output reg [2:0] hsize,
  output reg [2:0] hburst,
  output reg [3:0] hprot,
  output reg [1:0] htrans,
  output reg hmastlock,
  output reg hready,
  output reg [31:0] hwdata,
  output reg [31:0] dout
);
  //----------------------------------------------------
  // The definitions for state machine
  //----------------------------------------------------
  reg [1:0] state;
  reg [1:0] next_state;
  parameter idle = 2'b00;
  parameter add_phase = 2'b01;
  parameter wr_phase = 2'b10;
  parameter read_phase = 2'b11;
  //----------------------------------------------------
  // The state machine
  //----------------------------------------------------
  always @(posedge hclk, negedge hresetn) 
    begin
      if(!hresetn) 
        begin
          state <= idle;
        end
      else 
        begin
          state <= next_state;
      end
  end
  //----------------------------------------------------
  // State Transition
  //----------------------------------------------------
  always @(*) begin
    case(state)
      idle: begin
        if(enable == 1'b1) begin
          next_state = add_phase;
        end
        else begin
          next_state = idle;
        end
      end
      add_phase: 
        begin
          if(wr == 1'b1) 
            begin
              next_state = wr_phase;
            end
          else 
            begin    
              next_state = read_phase;  
            end
        end
      wr_phase: 
        begin
          if(enable == 1'b1) begin
            next_state = add_phase;
          end
          else 
            begin
              next_state = idle;
            end
        end
      read_phase: 
        begin
          if(enable == 1'b1) 
            begin
              next_state = add_phase;
            end
          else 
            begin
              next_state = idle;
            end
        end
      default: 
        begin
          next_state = idle;
        end
    endcase
  end 
  //----------------------------------------------------
  // Signals assertions
  //----------------------------------------------------
  always @(posedge hclk, negedge hresetn) 
    begin
      if(!hresetn) 
        begin
          sel <= 2'b00;
          haddr <= 32'h0000_0000;
          hwrite <= 1'b0;
          hsize <= 3'b000;
          hburst <= 3'b000;
          hprot <= 4'b0000;
          htrans <= 2'b00;
          hmastlock <= 1'b0;
          hready <= 1'b0;
          hwdata <= 32'h0000_0000;
          dout <= 32'h0000_0000;
        end
      else 
        begin
          case(next_state)
            idle: 
              begin 
                sel <= slave_sel;
                haddr <= addr;
                hwrite <= hwrite;
                hburst <= hburst;
                hready <= 1'b0;
                hwdata <= hwdata;
                dout <= dout;
              end
            add_phase: 
              begin 
                sel <= 	slave_sel;
                haddr <= addr;
                hwrite <= wr;
                hburst <= 3'b000;
                hready <= 1'b1;
                hwdata <= dina+dinb;
                dout <= dout;
              end
            wr_phase: 
              begin 
                sel <= sel;
                haddr <= addr;
                hwrite <= wr;
                hburst <= 3'b000;
                hready <= 1'b1;
                hwdata <= dina+dinb;
                dout <= dout;
              end
      
            read_phase: 
              begin
                sel <= sel;
                haddr <= addr;
                hwrite <= wr;
                hburst <= 3'b000;
                hready <= 1'b1;
                hwdata <= hwdata;
                dout <= hrdata;  
              end
            default: 
              begin
                sel <= slave_sel;
                haddr <= haddr;
                hwrite <= hwrite;
                hburst <= hburst;
                hready <= 1'b0;
                hwdata <= hwdata;
                dout <= dout;
              end
          endcase
        end
    end
endmodule