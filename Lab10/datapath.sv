`include "alu.sv"
`include "regfile.sv"
`include "imem.sv"
`include "dmem.sv"
`include "controller.sv"

module mips(
  input logic iClk,
  input logic iReset
);

  logic [31:0] ALU_ALUResult;
  logic [31:0] REG_SrcA;
  logic [31:0] REG_WriteData;
  logic [31:0] IMEM_InstF;
  logic [31:0] IMEM_InstD;
  logic [31:0] DMEM_ReadData;
  logic [31:0] pc;
  logic [4:0] WriteReg;
  logic [31:0] SrcB;
  logic [31:0] Result;
  logic [15:0] SignImm;
  logic [4:0] Rt;
  logic [4:0] Rd;
  
  logic CTL_RegWrite;
  logic CTL_MemWrite;
  logic CTL_RegDst;
  logic CTL_ALUSrc;
  logic CTL_MemtoReg;
  logic [2:0] CTL_ALUControl;
  
  assign Rt = IMEM_InstD[20:16];
  assign Rd = IMEM_InstD[15:11];
  assign WriteReg = CTL_RegDst ? Rd : Rt;
  assign SignImm = {{16{IMEM_InstD[15]}}, IMEM_InstD[15:0]};
  assign SrcB = CTL_ALUSrc ? SignImm : REG_WriteData;
  assign Result = CTL_MemtoReg ? DMEM_ReadData : ALU_ALUResult;
  
  alu ALU(
    .iA		(REG_SrcA),
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
    .oRdata1(REG_SrcA),
    .oRdata2(REG_WriteData)
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
        end else begin 
          IMEM_InstD <= IMEM_InstF;
        end

endmodule
