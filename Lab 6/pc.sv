module pc (
  input  [31:0] ipc,
  input clk, reset,
  output [31:0] opc
);
  reg [31:0] opc;

  always@(posedge clk)
    begin
      if(reset == 1)
        opc <= 0;
      else 
      	opc <= ipc + 4;
    end

endmodule