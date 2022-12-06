module controller(
  input logic [5:0] iOp,
  output logic oRegWrite,
  output logic oMemWrite,
  output logic [2:0] oALUControl
);

always@(*) begin
  case(iOp)
    35: begin
          oRegWrite <= 1;
          oMemWrite <= 0;
          oALUControl <= 3'b010;
    end
  endcase
end

endmodule