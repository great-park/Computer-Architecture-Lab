module sign_extend (
	input  [15:0] idata,
	output [31:0] odata
);
	reg [31:0] odata;

  always@(idata)
    begin
      odata[15:0] = idata[15:0];
      odata[31:16] = {16{idata[15]}};
    end

endmodule