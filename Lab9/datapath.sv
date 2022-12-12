`include "alu.sv"
`include "regfile.sv"
`include "imem.sv"
`include "dmem.sv"
`include "controller.sv"
`include "mux5.sv"
`include "mux32.sv"

module mips(
  input logic iClk,
  input logic iReset
);

  logic [31:0] ALU_ALUResult;
  logic [31:0] REG_SrcA;
  logic [31:0] REG_WriteData;
  logic [31:0] IMEM_Inst;
  logic [31:0] DMEM_ReadData;
  logic [31:0] pc;
  
  logic CTL_RegWrite;
  logic CTL_MemWrite;
  logic CTL_RegDst;
  logic CTL_ALUSrc;
  logic CTL_MemtoReg;
  logic [2:0] CTL_ALUControl;
  logic [4:0] WriteReg;
  logic [31:0] SrcB;
  logic [31:0] Result;
  
  alu ALU(
    .iA		(REG_SrcA),
    .iB		({{16{IMEM_Inst[15]}}, IMEM_Inst[15:0]}),
    .iF		(CTL_ALUControl),
    .oY		(ALU_ALUResult),
    .oZero	()
  );
  
  regfile REG(
    .iClk	(iClk),
    .iReset	(iReset),
    .iRaddr1(IMEM_Inst[25:21]),
    .iRaddr2(IMEM_Inst[20:16]),
    .iWaddr	(WriteReg),
    .iWe	(CTL_RegWrite),
    .iWdata	(Result),
    .oRdata1(REG_SrcA),
    .oRdata2(REG_WriteData)
  );
  
  imem IMEM(
    .iAddr	(pc),
    .oRdata	(IMEM_Inst)
  );
  
  dmem DMEM(
    .iClk	(iClk),
    .iWe	(CTL_MemWrite),
    .iAddr	(ALU_ALUResult),
    .iWdata	(REG_WriteData),
    .oRdata	(DMEM_ReadData)
  );
  
  controller CTL(
    .iOp		(IMEM_Inst[31:26]),
    .iFunct (IMEM_Inst[5:0]),
    .oRegWrite	(CTL_RegWrite),
    .oMemWrite	(CTL_MemWrite),
    .oRegDst(CTL_RegDst),
    .oALUSrc(CTL_ALUSrc),
    .oMemtoReg(CTL_MemtoReg),
    .oALUControl(CTL_ALUControl)
  );

  assign WriteReg = CTL_RegDst ? IMEM_Inst[15:11] : IMEM_Inst[20:16];
  assign SrcB = CTL_ALUSrc ? IMEM_Inst : REG_WriteData;
  assign Result = CTL_MemtoReg ? DMEM_ReadData : ALU_ALUResult;

  // mux5 MUX5(
  //   .in0(IMEM_Inst[20:16]),
  //   .in1(IMEM_Inst[15:11]),
  //   .sel(CTL_RegDst),
  //   .out(WriteReg)
  // );

  // mux32 MUX32a(
  //   .in0(REG_WriteData),
  //   .in1(IMEM_Inst),
  //   .sel(CTL_ALUSrc),
  //   .out(SrcB)
  // );

  // mux32 MUX32b(
  //   .in0(ALU_ALUResult),
  //   .in1(DMEM_ReadData),
  //   .sel(CTL_MemtoReg),
  //   .out(Result)
  // );

  always_ff@(posedge iClk, posedge iReset)
    if(iReset)
      pc <= 0;
    else 
      pc <= pc + 4;
  
endmodule
