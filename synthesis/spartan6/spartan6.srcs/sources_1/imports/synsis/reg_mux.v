module reg_mux (in,out,clk,rst,REG,CE);
parameter size=18;
parameter RSTTYPE="SYNC";
input [size-1:0] in;
input clk,rst,REG,CE;
output [size-1:0] out;
reg  [size-1:0]out_reg;
assign out=(REG)? out_reg:in;
generate
  case (RSTTYPE)
    "SYNC": begin
      always @(posedge clk) begin
           if(rst)
              out_reg<=0;
            else  
              if (CE)
                out_reg<=in;  
          end
    end
    
    "ASYNC":begin
      always @(posedge clk or posedge rst) begin
            if(rst)
              out_reg<=0;
            else  
              if(CE)
                out_reg<=in;   
          end
            
    end      
    
  endcase
endgenerate

endmodule 

