module bit_population_counter_tb;

parameter WIDTH = 32;

logic                       clk;
logic                       rst;

logic                       cmd_valid_i;
logic [( WIDTH - 1):0]      cmd_data_i;

logic                       data_valid_o;
logic [($clog2( WIDTH + 1)):0] data_o;

logic [( WIDTH - 1):0]      int_data;
logic [($clog2( WIDTH )):0] data_i_count;

bit [($clog2( WIDTH + 1)):0] rand_numb_unit;

bit_population_counter 
  bit_population_counter_dut     (
  .clk_i       ( clk          ),
  .srst_i      ( rst          ),
  
  .data_val_i  ( cmd_valid_i  ),
  .data_i      ( cmd_data_i   ),
  
  .data_val_o  ( data_valid_o ),
  .data_o      ( data_o       )
);

initial                                                
begin                                                  
  clk = 0;
  cmd_valid_i  = 0;
  rst = 0; 
  
  $display("Running testbench");                       
end                                                    

always 
  #5  clk =  ! clk;    //создание clk                                                
 
 event reset_trigger; //объявление событий
event reset_done_trigger; //

//блок формирования Reset
initial begin 
 forever begin //бесконечный цикл 
  @ (reset_trigger); //ждем события reset_trigger
  @ (posedge clk); //ждем negedge clk
  rst = 1;    //сброс
  @ (posedge clk); 
  rst = 0; 
  -> reset_done_trigger; //сигналим что reset выполнен
  end 
end

//Ход симуляции
initial  
begin : TEST_CASE 
  #11  -> reset_trigger; 
  @ (reset_done_trigger); 
  fork  // внутри fork все выполняется одновременно
    
    /*repeat (100) begin // 10 повторений
      @ (negedge clk); // negedge clk
      cmd_valid_i = $random; 
   end
   repeat (100) begin // 10 повторений
      @ (negedge clk); // negedge clk
      rst = $random; 
   end */
   @ (posedge clk);
   repeat (100)
	begin
	  rand_numb_unit = $urandom_range(WIDTH, 0);
      cmd_data_i = 2**(rand_numb_unit) - 1;
	  cmd_valid_i = |cmd_data_i;
		@ (posedge clk);
	end
  join //end fork
end
endmodule
