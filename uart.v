// file ke man sakhtam baraye taghir dadan.

module uart(rx, tx_data, startSend, tx, rx_data, rx_finish, tx_done, clock, reset);		
	
	// frequency of altera DE2 FPGA = 200 MHz. It means inernal clock frequency is about 100MHz 
	// baud rate = 9600
	// each bit can change in 100000000 / 9600 = 10416.66 clocks  	===> I put 10416 in the code instead.
// test:
// each 20 clock change bit
		
	input rx,startSend, clock, reset;
	input [7:0] tx_data;
	output reg tx_done = 1;
	
	output reg tx, rx_finish;
	output reg[7:0]rx_data;
	reg rxClock = 0;
	reg [5:0] rxClkCnt = 1; 		// in each clock it inreases 1 unit. resets at 20833
	reg [4:0]rxBitCnt = -1;
	reg buadRate = 9600;
	reg [2:0]rxState = 0;
	reg [7:0] rxTemp = 0;
	
	
	reg txClock = 0;
	reg [5:0] txClkCnt = 1;
	reg [4:0] txBitCnt = -1;
	reg [2:0] txState = 0;
	

	always@(posedge reset)
	begin
		txState = 0;
		txBitCnt = 0;
		tx_done = 1;
		rx_finish = 0;
		rxState = 0;
	end

	always@(posedge startSend)		// state 0   to   state 1
	begin
		txState = 1;
		txBitCnt = 0;
		tx = 0;
	end	
	
	
	always@(txClkCnt)
	begin
		if(txClkCnt == 2)                                                             //Chera 2?
		begin
			tx_done = 0;
		end
	end



	always@(posedge clock) 			// generating tx Clock which bits work with it
	begin
		if(txState == 1 || txState == 2 || txState == 3)
		begin
			if(txClkCnt == 20)
			begin
				txClock = ~txClock;
				txClkCnt = 1;
			end
		
			else if(txClkCnt == 10 || txClkCnt == 20)		// divide by two because it's half of rxClock period (each time rxClock toggles)
				begin
					txClock = ~txClock;
					txClkCnt = txClkCnt + 1;
				end
			else
			begin
				txClkCnt = txClkCnt + 1;
			end
		end
	end

	
	always@(posedge clock)
	begin
		if((txClkCnt == 1 || txClkCnt == 11) && txBitCnt  < 8 && txState != 2 && txState == 1)		// sampling
		begin
			tx = tx_data[txBitCnt];
			txBitCnt = txBitCnt + 1;			
		end
		else if(txClkCnt == 11 && txBitCnt == 8 && txState != 2)	// go to state 2
		begin
			txState = 2;
			tx = 1;
			txBitCnt = 0;
		end
		else if((txClkCnt == 11 || txClkCnt == 1) && txState == 2)	// go to state 0
		begin
			txState = 0;
			txBitCnt = 0;
			tx_done = 1;
		end		
	end



	always@(posedge clock) 			// generating rx Clock which bits work with it
	begin
	  if(rxState == 3)
	    begin
        if(rxClkCnt == 10)
	         rxState = 1;
		    rxClkCnt = rxClkCnt + 1;
      end
	      
		else if(rxState == 1 || rxState == 2)
		 begin
			if(rxClkCnt == 20)
				rxClkCnt = 1;
			else if(rxClkCnt == 10 || rxClkCnt == 20)		// divide by two because it's half of rxClock period (each time rxClock toggles)
			 begin
					rxClock = ~rxClock;
					rxClkCnt = rxClkCnt + 1;
				end
			else
			 begin
				rxClkCnt = rxClkCnt + 1;
			 end
		 end
	end
	
	always@(posedge clock)
	begin
		if((rxClkCnt == 6 || rxClkCnt == 16) && rxBitCnt  < 8 && rxState != 3)		// sampling
		begin
			rxTemp[rxBitCnt] = rx;
			rxBitCnt = rxBitCnt + 1;			
		end
		else if(rxClkCnt == 20 && rxBitCnt == 8)	// go to state 2
		begin
			rx_finish = 1;
			//rxState = 2;
			rxTemp[rxBitCnt] = rx;
			rx_data = rxTemp;
			//rxBitCnt = rxBitCnt + 1;
			
			//rx_finish = 0;
      rxState = 0;
      rxBitCnt = 0;

		end
		//else if((rxClkCnt == 6 || rxClkCnt == 16) && rxBitCnt == 9)	// go to state 0
		//begin
			//rx_finish = 0;
			//rxState = 0;
		//end		
	end

	always@(negedge rx)
	begin
		if(rxState == 0)
		begin
			rx_finish = 0;
			rxState = 3;		// go to state 1
			rxBitCnt = 0;
			rxClkCnt = 1;
		end
	end

endmodule









