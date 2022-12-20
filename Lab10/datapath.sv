`include "alu.sv"
`include "regfile.sv"
`include "imem.sv"
`include "dmem.sv"
`include "controller.sv"

module mips(
  input logic iClk,
  input logic iReset
);



  logic [31:0] IMEM_InstF;
  logic [31:0] IMEM_InstD;
  logic [31:0] REG_SrcAD;
  logic [31:0] REG_SrcAE;
  logic [15:0] SignImmD;
  logic [15:0] SignImmE;
  logic [4:0] RtD;
  logic [4:0] RdD;
  logic [4:0] RtE;
  logic [4:0] RdE;



  logic [31:0] ALU_ALUResultE;
  logic [31:0] ALU_ALUResultM;
  logic [31:0] SrcBE;
  logic [31:0] REG_WriteDataD;
  logic [31:0] REG_WriteDataE;
  logic [4:0] WriteRegE;
  logic [4:0] WriteRegM;
  logic [4:0] WriteRegW;
  logic [31:0] DMEM_ReadDataM;
  logic [31:0] DMEM_ReadDataW;

  logic [31:0] pc;
  logic [31:0] Result;


  logic CTL_ALUSrcD;
  logic CTL_ALUSrcE;

  logic [2:0] CTL_ALUControlD;
  logic [2:0] CTL_ALUControlE;
  
  logic CTL_RegWrite;
  logic CTL_MemWrite;
  logic CTL_RegDst;
  
  logic CTL_MemtoRegD;
  logic CTL_MemtoRegE;
  logic CTL_MemtoRegM;
  logic CTL_MemtoRegW;
  
  
  assign RtD = IMEM_InstD[20:16];
  assign RdD = IMEM_InstD[15:11];
  assign WriteReg = CTL_RegDst ? Rd : Rt;
  assign SignImmD = {{16{IMEM_InstD[15]}}, IMEM_InstD[15:0]};
  assign SrcB = CTL_ALUSrc ? SignImmD : REG_WriteData;
  assign Result = CTL_MemtoReg ? DMEM_ReadData : ALU_ALUResult;
  
  alu ALU(
    .iA		(REG_SrcAE),
    .iB		(SrcB),
    .iF		(CTL_ALUControl),
    .oY		(ALU_ALUResult),
    .oZero	()
  );
  
  regfile REG(
    .iClk	(iClk),
    .iReset	(iReset),
    .iRaddr1(IMEM_InstD[25:21]),
    .iRaddr2(IMEM_InstD[20:16]),
    .iWaddr	(WriteReg),
    .iWe	(CTL_RegWrite),
    .iWdata	(Result),
    .oRdata1(REG_SrcAD),
    .oRdata2(REG_WriteDataD)
  );
  
  imem IMEM(
    .iAddr	(pc),
    .oRdata	(IMEM_InstF)
  );
  
  dmem DMEM(
    .iClk	(iClk),
    .iReset	(iReset),
    .iWe	(CTL_MemWrite),
    .iAddr	(ALU_ALUResult),
    .iWdata	(REG_WriteData),
    .oRdata	(DMEM_ReadData)
  );
  
  controller CTL(
    .iOp		(IMEM_InstD[31:26]),
    .iFunc		(IMEM_InstD[5:0]),
    .oRegWrite	(CTL_RegWrite),
    .oMemWrite	(CTL_MemWrite),
    .oRegDst	(CTL_RegDst),
    .oALUSrc	(CTL_ALUSrc),
    .oMemtoReg	(CTL_MemtoReg),
    .oALUControl(CTL_ALUControl)
  );
  
  always_ff@(posedge iClk, posedge iReset)
    if(iReset)
      pc <= 0;
    else 
      pc <= pc + 4;

    always_ff@(posedge iClk, posedge iReset)
      if(iReset) begin
      	  IMEM_InstD <= 0;
          REG_SrcAE <= 0;
          REG_WriteDataE <= 0;
          RtE <= 0;
          RdE <= 0;
          SignImmE <= 0;
        end else begin 
          IMEM_InstD <= IMEM_InstF;
          REG_SrcAE <= REG_SrcAD;
          REG_WriteDataE <= REG_WriteDataD;
          RtE <= RtD;
          RdE <= RdD;
          SignImmE <= SignImmD;
        end

endmodule
