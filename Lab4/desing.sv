module alu(input [31:0] iA, input [31:0] iB, input [2:0] iF, 
           output reg [31:0] oY, output reg oZero);
  always_comb
    begin
      case(iF)
        3'b000 : oY = iA & iB;
        3'b001 : oY = iA | iB;
        3'b010 : oY = iA + iB;
        3'b100 : oY = iA & ~iB;
        3'b101 : oY = iA | ~iB;
        3'b110 : oY = iA - iB;
        3'b111 : oY = iA < iB;
      endcase
    end
  always_comb
    begin
    if (oY == 0)
      oZero = 1;
    else
      oZero = 0;
    end
endmodule 


