module regfile (iRaddr1, iRaddr2, iWaddr, oRdata1, oRdata2, iWdata, iWe, iClk, iReset);
	input [4:0] iRaddr1, iRaddr2, iWaddr;
	input [31:0] iWdata;
	input iClk, iReset, iWe;
	output [31:0] oRdata1, oRdata2;
	reg [31:0] reg_file [31:0];
	integer k;
	assign oRdata1 = reg_file[iRaddr1];
	assign oRdata2 = reg_file[iRaddr2];
	always @(posedge iClk or posedge iReset)
	begin
		if (iReset==1'b1)
		begin
			for (k=0; k<32; k=k+1) 
			begin
				reg_file[k] = 32'b0;
			end
		end 
      else if (iWe == 1'b1) 
        begin 
        	if(iWaddr > 0) reg_file[iWaddr] = iWdata; 
      	end
	end
endmodule