module spartan6(A,B,D,C,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,CLK,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);
//******************************Parameter****************************************
parameter A0REG = 0;
parameter A1REG = 1;  
parameter B0REG=  0;  
parameter B1REG = 1;  
parameter CREG = 1;  
parameter DREG = 1;  
parameter MREG = 1;  
parameter PREG = 1;  
parameter CARRYINREG =  1;  
parameter CARRYOUTREG = 1;  
parameter OPMODEREG = 1;  
parameter CARRYINSEL = "OPMODE5";  
parameter B_INPUT= "DIRECT";  
parameter RSTTYPE = "SYNC";                  
//***************************ports***********************************************
input [17:0] A,B,D,BCIN;
input [47:0] C,PCIN;
input [7:0] OPMODE;
input CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,CLK;
output [17:0] BCOUT;
output [47:0] PCOUT,P;
output [35:0] M;
output CARRYOUT,CARRYOUTF;
//***********************************internal signals****************************
wire [17:0]D_out,B0_in,B0_out,B1_in,B1_out,A0_out,A1_out,add_sub_resualt1;
wire [47:0]C_out,X_out,Z_out,P_in,M_out_extended,D_A_B;
wire [7:0]opmode_out;
wire [35:0] M_in,M_out;
wire CYI_in,CIN;
wire CYO_in;
//***************************functionality***************************************
reg_mux #(.size(18),.RSTTYPE(RSTTYPE))D_REG(D,D_out,CLK,RSTD,DREG,CED);
assign B0_in=(B_INPUT=="DIRECT")?B:(B_INPUT=="CASCADE")?BCIN:0;
reg_mux #(.size(18),.RSTTYPE(RSTTYPE))B0_REG(B0_in,B0_out,CLK,RSTB,B0REG,CEB);
reg_mux #(.size(18),.RSTTYPE(RSTTYPE))A0_REG(A,A0_out,CLK,RSTA,A0REG,CEA);
reg_mux #(.size(48),.RSTTYPE(RSTTYPE))C_REG(C,C_out,CLK,RSTC,CREG,CEC);

reg_mux #(.size(8),.RSTTYPE(RSTTYPE))opmode_REG(OPMODE,opmode_out,CLK,RSTOPMODE,OPMODEREG,CEOPMODE);
assign add_sub_resualt1=(opmode_out[6])?D_out-B0_out:D_out+B0_out;
assign B1_in=(opmode_out[4])?add_sub_resualt1:B0_out;
reg_mux #(.size(18),.RSTTYPE(RSTTYPE))B1_REG(B1_in,B1_out,CLK,RSTB,B1REG,CEB);
reg_mux #(.size(18),.RSTTYPE(RSTTYPE))A1_REG(A0_out,A1_out,CLK,RSTA,A1REG,CEA); 
assign BCOUT=B1_out;

assign M_in= B1_out*A1_out ;
reg_mux #(.size(36),.RSTTYPE(RSTTYPE))M_REG(M_in,M_out,CLK,RSTM,MREG,CEM); 
assign M=~(~M_out);
assign CYI_in=(CARRYINSEL=="OPMODE5")?opmode_out[5]:(CARRYINSEL=="CARRYIN")?CARRYIN:0;
reg_mux #(.size(1),.RSTTYPE(RSTTYPE)) CYI (CYI_in,CIN,CLK,RSTCARRYIN,CARRYINREG,CECARRYIN); 

assign M_out_extended={{12{1'b0}},M_out};
assign D_A_B={D_out[11:0],A1_out,B1_out};
mux_3to1 X(D_A_B,PCOUT,M_out_extended,48'b0,opmode_out[1:0],X_out);
mux_3to1 Z(C_out,PCOUT,PCIN,48'b0,opmode_out[3:2],Z_out);
assign {CYO_in,P_in}=(opmode_out[7])?(Z_out-(X_out+CIN)):(Z_out+X_out+CIN);
reg_mux #(.size(48),.RSTTYPE(RSTTYPE))P_REG(P_in,P,CLK,RSTP,PREG,CEP); 
reg_mux #(.size(1),.RSTTYPE(RSTTYPE)) CYO (CYO_in,CARRYOUT,CLK,RSTCARRYIN,CARRYOUTREG,CECARRYIN);
assign PCOUT=P;
assign CARRYOUTF=CARRYOUT;


endmodule

