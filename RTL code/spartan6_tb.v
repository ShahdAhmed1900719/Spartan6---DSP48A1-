/*module reg_mux_tb();
reg [17:0]in;
wire [17:0]out;
reg clk,rst,REG;

reg_mux m1(in,out,clk,rst,REG);

initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end

initial begin
    rst<=1;//SYNC
    @(negedge clk);
    rst<=0;
    REG<=1;   //reg
    @(negedge clk);
    repeat(50) begin
      in<=$random;
      @(negedge clk);
    end
    REG<=0;   //buffer
    @(negedge clk);
    repeat(50) begin
      in<=$random;
      #10;
    end
    $stop;    

end
endmodule*/


module spartan6_tb();
reg [17:0] A,B,D,BCIN;
reg [47:0] C,PCIN;
reg [7:0] OPMODE;
reg CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,clk;
wire [17:0] BCOUT;
wire [47:0] PCOUT,,P;
wire [35:0] M;
wire CARRYOUT,CARRYOUTF;

spartan6 test1(A,B,D,C,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,clk,PCIN1,BCOUT1,PCOUT1,P1,M1,CARRYOUT1,CARRYOUTF1);

initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end 

initial begin
/*****************************************************use cascaded reg of inputs *************************************/    
CEA<=1;
CEB<=1;
CEM<=1;
CEP<=1;
CEC<=1;
CED<=1;
CECARRYIN<=1;
CEOPMODE<=1;
RSTA<=1;
RSTB<=1;
RSTM<=1;
RSTP<=1;
RSTC<=1;
RSTD<=1;
RSTCARRYIN<=1;
RSTOPMODE<=1;
@(negedge clk);
RSTA<=0;
RSTB<=0;
RSTM<=0;
RSTP<=0;
RSTC<=0;
RSTD<=0;
RSTCARRYIN<=0;
RSTOPMODE<=0;

@(negedge clk);
repeat(50)begin
  D<=$random;
  B<=$random;
  A<=$random;
  C<=$random;
  BCIN<=$random;
  OPMODE<=$random;
  PCIN<=$random;
  CARRYIN<=$random;
  @(negedge clk);
end

/*************************************************direct input ****************************************/


$stop;
end





endmodule
