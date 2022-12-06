module controller(
  input logic [5:0] iOp,
  output logic oRegWrite,
  output logic oMemWrite,
  output logic [2:0] oALUControl
);

always@(iOp) begin
  oRegWrite = 1'b0;
  oMemWrite = 1'b0;
  oALUControl = 3'b00;

  if (iOp == 6'h23) begin
    oMemWrite = 1'b0;
    oRegWrite = 1'b1;
    oALUControl = 3'b010;
  end
end


endmodule
 
  