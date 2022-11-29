`include "alu.sv"
`include "regfile.sv"
`include "imem.sv"
`include "dmem.sv"
`include "sign_extend.sv"
`include "pc.sv"

module datapath(
  input logic iClk,
  input logic iReset,
  input logic iRegWrite,
  input logic iMemWrite,
  input logic [2:0] iALUControl
);
  wire [31:0] ipc, opc;
  pc pc_0(.ipc(0), .clk(iClk), .reset(iReset), .opc(opc));
  
  wire [31:0] instruction;
  imem imem_0(.iAddr(opc), .oRdata(instruction));
  
  wire [31:0] oRdata1, oRdata2;
  regfile regfile_0(
    .iClk(iClk), 
    .iReset(iReset), 
    .iRaddr1(instruction[25:21]), 
    .iRaddr2(instruction[20:16]),
    .iWaddr(instruction[20:16]),
    .iWe(iRegWrite),
    .iWdata(read_data),
    .oRdata1(oRdata1),
    .oRdata2(oRdata2)
  );
  
  wire [31:0] sign_ex;
  sign_extend sign_extend_0(
    .idata(instruction[15:0]),
    .odata(sign_ex)
  );
  
  wire [31:0] alu_result;
  wire oZero;
  alu alu_0(
    .iA(oRdata1),
    .iB(sign_ex),
    .iF(iALUControl),
    .oY(alu_result),
    .oZero(oZero)
  );
  
  wire [31:0] read_data;
  dmem dmem_0(
    .iClk(iClk),
    .iWe(iMemWrite),
    .iAddr(alu_result),
    .iWdata(oRdata2),
    .oRdata(read_data)
  );
  
  
endmodule
