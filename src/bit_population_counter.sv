module bit_population_counter #(
  parameter WIDTH = 32
  )(
  input                                    clk_i,      //clock signal
  input                                    srst_i,     //synchronous reset
	
  input        [( WIDTH - 1 ):0]           data_i,     //input data
  input                                    data_val_i, //input validaty signal
	
  output logic [( $clog2( WIDTH ) + 1 ):0] data_o,     //output data
  output logic                             data_val_o  //output validaty signal
);
	
	
logic [($clog2(WIDTH-1)+1):0] data_i_count;


always_ff @( posedge clk_i )
  begin
    if( srst_i ) begin
      data_val_o <= '0;
      data_o     <= '0;
    end
    else begin
      data_val_o <= data_val_i;
    if(data_val_i) begin
      data_o <= data_i_count;
    end // end if data_val_i == 1
    else begin
      data_o <= '0;
    end//  end else data_val_i != 1
  end // end else srst_i == 1
end // end always_ff
	
//countin the number of units
always_comb
begin
  data_i_count = '0;
  for(int i = 0; i < WIDTH; i++)
    begin
	   if( srst_i ) begin
        data_i_count = '0;
	   end // end if srst_i == 1
      else begin
        data_i_count += data_i[i];
      end // end else srts_i != 1
    end // end for
end // end always_comb

endmodule

