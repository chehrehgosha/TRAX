// file copy baraye khodam va anjam taghirat


module tranceiver(startGame, tx, move_out, end_receive, color, rx, move_in, start_transmit, clock, reset);

	// important note:
	// 1. Har moghe khastim move_in ra ok konim ta sample shavad,
	// bayad faghat 1 clock start_transmit ra 1 konim o badesh 0


	// startGame ro khodam ezafe kardam chon dar soorate proje ebham bood k signale shoroee bazi chi hast
	// end_receive ro baraye shoro'e bazi nazashtam. baraye 

	output wire tx;
	output reg end_receive;
	output reg color;
	output reg [21:0] move_out;
	output reg startGame;
	wire [7:0] rx_data;

	input wire rx, start_transmit, clock, reset;
	input wire [21:0] move_in;
	

	// sending signals(tx)
	reg [7:0] tx_data;
	reg startSend;
	wire tx_done, rx_finish;
	reg [9:0] columnBits;
	reg [7:0]column1 = 0;
	reg [7:0]column2 = 0;
	reg [9:0] rowBits;
	reg [7:0]row1 = 0;
	reg [7:0]row2 = 0;
	reg [7:0]row3 = 0;
	reg [7:0]temp;
	reg [1:0] typeBit;
	reg [7:0] type;
	reg [7:0]nextLine = "\n";	
	reg [2:0] tState = 2;
	reg [2:0] sentCharCnt;
	reg [11:0] tClkCnt;
  reg done = 0;

		

	uart u1(rx, tx_data, startSend, tx, rx_data, rx_finish, tx_done, clock, reset);

		
	// receiving signals (rx)
	//	reg [11:0] rClkCnt;
	reg [4:0] rState =0;
	reg [9:0] rColumnBits;
	reg [7:0] rColumn1 = 0;
	reg [7:0] rColumn2 = 0;
	reg [9:0] rRowBits;
	reg [7:0] rRow1 = 0;
	reg [7:0] rRow2 = 0;
	reg [7:0] rRow3;
	reg [1:0] rTypeBit;
	reg [7:0] rType;
	reg [7:0] rNextLine;
	
	always@(posedge rx_finish)
	begin	
		if(rState == 0)		// receive "-"
		begin
			rState = 1;
		end
	
		else if(rState == 1)	// receive color
		begin
			if(rx_data == "W")
			begin	
				color = 1;	// 1 for White
			end
			else if(rx_data == "B")
			begin
				color = 0;	// 0 for Black
			end
			rState = 2;
		end
	
		else if(rState == 2)
		begin
			rState = 3;
			startGame = 1;	
		end
		
		else if(rState == 3) // column1 ro migire
		begin
			rState = 4;
			rColumn1 = rx_data;	
			end_receive = 0;		
		end		
		
		else if(rState == 4)
		begin	
			if(rx_data > 63 && rx_data < 91)	// second byte is a letter(column2) not a number
			begin
				rColumn2 = rx_data;
				rState = 5;
			end
			else if(rx_data > 47 && rx_data < 58)	//  second byte is a number(row1)
 			begin
				rRow1 = rx_data;
				rState = 6;
			end
		end
		
		else if(rState == 5)
		begin
			rRow1 = rx_data;
			rState = 6;
		end
	
		else if(rState == 6)
		begin	
			if(rx_data > 47 && rx_data < 58)	// next byte is a number(row2)
			begin
				rState = 7;
				rRow2 = rx_data;
			end
			else 		// next byte is movement type: +  or  \  or  /
			begin
				rType = rx_data;
				rState = 9;
			end
		end

		else if(rState == 7)
		begin
			if(rx_data > 47 && rx_data < 58)	// next byte is a number(row3)
			begin
				rState = 8;
				rRow3 = rx_data;
			end
			else 		// next byte is movement type: +  or  \  or  /
			begin
				rType = rx_data;
				rState = 9;
			end
		end

		else if(rState == 8)
		begin
			rState = 9;
			rType = rx_data;
	  end
		
		else if(rState == 9)
		begin
			if(rType == "+")
			begin
				rTypeBit = 2;
			end
	    else if(rType == "\\")
			begin
				rTypeBit = 1;
			end
	    else if(rType == "/")
			begin
				rTypeBit = 3;
			end

			if(rColumn2 == 0)
			begin
				rColumnBits = rColumn1 - 64;
			end
			else 
			begin
				rColumnBits = (rColumn2 - 64) * 26 + rColumn1 - 64;
			end
		
			if(rRow1 >= 48)
			begin
				rRowBits = rRow1 - 48;
			end
			if(rRow2 >= 48)
			begin
				rRowBits = (rRow2 - 48) *  10;
			end
			if(rRow3 >= 48)
			begin
				rRowBits = (rRow3 - 48) * 100;
			end
			move_out[1:0] = rTypeBit;
			move_out[21:12] = rColumnBits;
			move_out[11:2] = rRowBits;
			end_receive = 1;
			rState = 3;
		end
	end







	always@(posedge clock)		// counting clocks 0 to 200 for sending each char(byte) with uart
	begin
		if(tState == 3)
		begin	
			tClkCnt = tClkCnt + 1;
		end
	end
	
	always@(clock)
	begin
		$display("tState = %d", tState);
		$display("tx_done = %d", tx_done);
		$display("sentCharCnt = %d", sentCharCnt);
		$display("tClkCnt = %d", tClkCnt);
		$display("startSend = ", startSend);
	end
	
	
	reg [2:0] sentCharCntFake;
	always@(posedge clock)
	begin
		sentCharCntFake = sentCharCnt;
	end
		
	reg  ifByte1	= 0;
	reg		ifByte3 = 0;
	reg	 ifByte2 = 0;
	reg	  ifByte4 = 0;
	reg	  ifByte5 = 0;
	reg	  ifByte6 = 0;
	reg	  ifByte7 = 0;
  
  
	always@(posedge clock)
	begin
		
		
		
		if(tState == 3  && tx_done == 1 && sentCharCnt == 0 && tClkCnt == 1)	// start sending first byte
		begin
			tx_data = column1;
			sentCharCnt = 1;
			startSend = 1;
		end
		else if(tState == 3  && tx_done == 0 && sentCharCnt == 1)	// while sending first byte, turn off startSend to get ready next byte
		begin	
			startSend = 0;
		end

		/////////////////
	
		else if(tState == 3 && tx_done == 1 && sentCharCnt == 1 && tClkCnt != 3)	// start sending second byte finished
		begin
			if(column2 != 0)	// column has two letters
			begin
			  tx_data = column2;
			  startSend = 1;
				sentCharCnt = 2;
			end
			else			// column has just one letter.
			begin
				sentCharCnt = 2;
				startSend = 0;
			end
		end
		// dadane takhir
		else if(tState == 3 && sentCharCnt == 2 && ifByte2 == 0)
		begin
		  startSend = 0;
			ifByte2 = 1;
		end


    //////////////////


		else if(tState == 3  && tx_done == 1 && sentCharCntFake == 2 && ifByte2 == 1)	// start sending first row byte
		begin
			tx_data = row1;
			startSend = 1;
			sentCharCnt = sentCharCnt + 1;
		end
		else if(tState == 3 && sentCharCntFake == 3 && ifByte3 == 0)	// while sending first row byte, turn off startSend to get ready next byte
		begin	
			startSend = 0;
			ifByte3 = 1;
		end


    /////////////////


		else if(tState == 3 && tx_done == 1 && sentCharCntFake == 3 && ifByte3 == 1)	// if we have second row2
		begin
			if(row2 != "0" || row3 != "0")				
			begin
				tx_data = row2;
				startSend = 1;
				sentCharCnt = sentCharCnt + 1;
			end
			else
			begin	
				sentCharCnt = 4;
				startSend = 0;
			end
		end
		// dadane takhir
		else if(tState == 3 && sentCharCnt == 4 && ifByte4 == 0)
		begin
		  startSend = 0;
			ifByte4 = 1;
		end
		
		
		
		
		/////////////////
		
		
		
		
		else if(tState == 3 && tx_done == 1 && sentCharCnt == 4 && ifByte4 == 1)	// if we have row3
		begin
			if(row3 != "0")
			begin
				tx_data = row3;
				sentCharCnt = sentCharCnt + 1;
				startSend = 1;
			end
			else
			begin
				sentCharCnt = 5;
				startSend = 0;
			end
		end
		else if(tState == 3 && sentCharCnt == 5 && ifByte5 == 0)
		begin
			startSend = 0;
			ifByte5 = 1;
		end
		
		
		
		/////////////////
		
		
		
		else if(tState == 3 && tx_done == 1  && sentCharCnt == 5 && ifByte5 == 1)	// sending type of instruction
		begin
			tx_data = type;
			sentCharCnt = 6;
			startSend = 1;
		end
		
		else if(tState == 3 && sentCharCnt == 6 && ifByte6 == 0)
		begin
			startSend = 0;
			ifByte6 = 1;
		end
				

    ///////////////////


		else if(tState == 3 && tx_done == 1 && sentCharCnt == 6 && ifByte6 == 1)
		begin
			tx_data = "\n";
			sentCharCnt = 7;
			startSend = 1;
		end
		
		else if(tState == 3 && sentCharCnt == 6 && ifByte7 == 0)
		begin
			startSend = 0;
			ifByte7 = 1;
		end
		
		else if(tState == 3 && sentCharCnt ==7 && ifByte7 == 1)
		begin
			startSend = 0;
			sentCharCnt = 0;
			
			tState = 2;		// go to state 2;
			tClkCnt = 0;
			ifByte3 = 0;
		  ifByte2 = 0;
		  ifByte4 = 0;
		  ifByte5 = 0;
		  ifByte6 = 0;
		  ifByte7 = 0;
			startSend = 0;

		end
	end

	
	

//	always@(posedge clock) //momkene ezafe bashe
//	begin
//		if(tState == 3)
//		begin	
//			if(tClkCnt == 0)
//			begin
//				tx_data = row1;
//				startSend = 1;
//			end
//		end
//	end


//		always@(posedge start_transmit)
//   	begin
//		if(tState == 0) // barresi shavad
//		begin
//			tState = 1;
//				
//		end
//		
//		if(tState == 2)  //ezafe
//		begin
//			tState = 3;
//			tx_data = column1;
//			startSend = 1;
//			sentCharCnt = 0;
//			$display("start_transmit: sentCharCnt = 0");
//		end
//	end
		
	
	always@(posedge start_transmit)
	begin	
		if(tState == 2)
		begin
			tState = 4;
			sentCharCnt = 0;
			
			columnBits = move_in[21:12];
			rowBits = move_in[11:2];
			typeBit = move_in[1:0];
			done =0;
		end 
	end
	
	always@(posedge reset)
	begin
		columnBits = move_in[21:12];
		rowBits = move_in[11:2];
		typeBit = move_in[1:0];
			$display("reset: sentCharCnt = 0");
		sentCharCnt = 0;
		tClkCnt = 0;
		ifByte3 = 0;
    		ifByte2 = 0;
		startSend = 0;
	end
	
	
//	always@(negedge start_transmit) //barresi
//	begin
//		sentCharCnt = 1;
//	end 
	

	// decompose 22 bit input to  parts, generate chars
	always@(posedge clock)
	begin	
	  if(tState==4)
	  begin
	    
		// generating column	
		if(columnBits == 0)
		begin
			column1 = "@";
		end
		else if(columnBits % 26 == 1)
		begin
			column1 = "A";
		end
		else if(columnBits % 26 == 2)
		begin
			column1 = "B";
		end
		else if(columnBits % 26 == 3)
		begin
			column1 = "C";
		end
		else if(columnBits % 26 == 4)
		begin
			column1 = "D";
		end
		else if(columnBits % 26 == 5)
		begin
			column1 = "E";
		end
		else if(columnBits % 26 == 6)
		begin
			column1 = "F";
		end
		else if(columnBits % 26 == 7)
		begin
			column1 = "G";
		end
		else if(columnBits % 26 == 8)
		begin
			column1 = "H";
		end
		else if(columnBits % 26 == 9)
		begin
			column1 = "I";
		end
		else if(columnBits % 26 == 10)
		begin
			column1 = "J";
		end
		else if(columnBits % 26 == 11)
		begin
			column1 = "K";
		end
		else if(columnBits % 26 == 12)
		begin
			column1 = "L";
		end
		else if(columnBits % 26 == 13)
		begin
			column1 = "M";
		end
		else if(columnBits % 26 == 14)
		begin
			column1 = "N";
		end
		else if(columnBits % 26 == 15)
		begin
			column1 = "O";
		end
		else if(columnBits % 26 == 16)
		begin
			column1 = "P";
		end
		else if(columnBits % 26 == 17)
		begin
			column1 = "Q";
		end
		else if(columnBits % 26 == 18)
		begin
			column1 = "R";
		end
		else if(columnBits % 26 == 19)
		begin
			column1 = "S";
		end
		else if(columnBits % 26 == 20)
		begin
			column1 = "T";
		end
		else if(columnBits % 26 == 21)
		begin
			column1 = "U";
		end
		else if(columnBits % 26 == 22)
		begin
			column1 = "V";
		end
		else if(columnBits % 26 == 23)
		begin
			column1 = "W";
		end
		else if(columnBits % 26 == 24)
		begin
			column1 = "X";
		end
		else if(columnBits % 26 == 25)
		begin
			column1 = "Y";
		end
		else if(columnBits % 26 == 0)
		begin
			column1 = "Z";
		end
		//uart u1(rx, 

		if((columnBits / 26 == 0) || columnBits == 26)
		begin
			column2 = 0;
		end
		else if(columnBits / 26 == 1 || columnBits == 52)
		begin
			column2 = "A";
		end
		else if(columnBits / 26 == 2 || columnBits == 78)
		begin
			column2 = "B";
		end
		else if(columnBits / 26 == 3 || columnBits == 104)
		begin
			column2 = "C";
		end
		else if(columnBits / 26 == 4 || columnBits == 130)
		begin
			column2 = "D";
		end
		else if(columnBits / 26 == 5 || columnBits == 156)
		begin
			column2 = "E";
		end
		else if(columnBits / 26 == 6 || columnBits == 182)
		begin
			column2 = "F";
		end
		else if(columnBits / 26 == 7 || columnBits == 208)
		begin
			column2 = "G";
		end
		else if(columnBits / 26 == 8 || columnBits == 234)
		begin
			column2 = "H";
		end
		else if(columnBits / 26 == 9 || columnBits == 260)
		begin
			column2 = "I";
		end
		else if(columnBits / 26 == 10 || columnBits == 286)
		begin
			column2 = "J";
		end
		else if(columnBits / 26 == 11 || columnBits == 312)
		begin
			column2 = "K";
		end
		else if(columnBits / 26 == 12 || columnBits == 338)
		begin
			column2 = "L";
		end
		else if(columnBits / 26 == 13 || columnBits == 364)
		begin
			column2 = "M";
		end
		else if(columnBits / 26 == 14 || columnBits == 390)
		begin
			column2 = "N";
		end
		else if(columnBits / 26 == 15 || columnBits == 416)
		begin
			column2 = "O";
		end
		else if(columnBits / 26 == 16 || columnBits == 442)
		begin
			column2 = "P";
		end
		else if(columnBits / 26 == 17 || columnBits == 468)
		begin
			column2 = "Q";
		end
		else if(columnBits / 26 == 18 || columnBits == 494)
		begin
			column2 = "R";
		end
		else if(columnBits / 26 == 19 || columnBits == 520)
		begin
			column2 = "S";
		end
		else if(columnBits / 26 == 20 || columnBits == 546)
		begin
			column2 = "T";
		end
		else if(columnBits / 26 == 21 || columnBits == 572)
		begin
			column2 = "U";
		end
		else if(columnBits / 26 == 22 || columnBits == 598)
		begin
			column2 = "V";
		end
		else if(columnBits / 26 == 23 || columnBits == 624)
		begin
			column2 = "W";
		end
		else if(columnBits / 26 == 24 || columnBits == 650)
		begin
			column2 = "X";
		end
		else if(columnBits / 26 == 25 || columnBits == 676)
		begin
			column2 = "Y";
		end
		else if(columnBits / 26 == 26 || columnBits == 702)
		begin
			column2 = "Z";
		end
	

		// generating rows
		if(rowBits % 10 == 0)
		begin
			row1 = "0";
		end
		else if(rowBits % 10 == 1)
		begin
		row1 = "1";
			end
		else if(rowBits % 10 == 2)
		begin
			row1 = "2";
		end
		else if(rowBits % 10 == 3)
		begin
			row1 = "3";
		end
		else if(rowBits % 10 == 4)
		begin
			row1 = "4";
		end
		else if(rowBits % 10 == 5)
		begin
			row1 = "5";
		end
		else if(rowBits % 10 == 6)
		begin
			row1 = "6";
		end
		else if(rowBits % 10 == 7)
		begin
			row1 = "7";
		end
		else if(rowBits % 10 == 8)
		begin
			row1 = "8";
		end
		else if(rowBits % 10 == 9)
		begin
			row1 = "9";
		end
	
	
	
		if((rowBits / 10) % 10 == 0)
		begin
			row2 = "0";
		end
		else if((rowBits / 10) % 10 == 1)
		begin
			row2 = "1";
		end
		else if((rowBits / 10) % 10 == 2)
		begin
			row2 = "2";
		end
		else if((rowBits / 10) % 10 == 3)
		begin
			row2 = "3";
		end
		else if((rowBits / 10) % 10 == 4)
		begin
			row2 = "4";
		end
		else if((rowBits / 10) % 10 == 5)
		begin
			row2 = "5";
		end
		else if((rowBits / 10) % 10 == 6)
		begin
			row2 = "6";
		end
		else if((rowBits / 10) % 10 == 7)
		begin
			row2 = "7";
		end
		else if((rowBits / 10) % 10 == 8)
		begin
			row2 = "8";
		end
		else if((rowBits / 10) % 10 == 9)
		begin
			row2 = "9";
		end
		
		
		if((rowBits / 100) % 10 == 0)
		begin
			row3 = "0";
		end
		else if((rowBits / 100) % 10 == 1)
		begin	
			row3 = "1";
		end
		else if((rowBits / 100) % 10 == 2)
		begin	
			row3 = "2";
		end
		else if((rowBits / 100) % 10 == 3)
		begin	
			row3 = "3";
		end
		else if((rowBits / 100) % 10 == 4)
		begin	
			row3 = "4";
		end
		else if((rowBits / 100) % 10 == 5)
		begin	
			row3 = "5";
		end
		else if((rowBits / 100) % 10 == 6)
		begin
			row3 = "6";
		end
		else if((rowBits / 100) % 10 == 7)
		begin
			row3 = "7";
		end
		else if((rowBits / 100) % 10 == 8)
		begin	
			row3 = "8";
		end
		else if((rowBits / 100) % 10 == 9)
		begin	
			row3 = "9";
		end
		

		// generating types
		if(typeBit == 2)		//  0 for +,   1 for \,   2 for /
		begin
			type = "+";
		end
		else if(typeBit == 1)
		begin
			type = "\\";
		end
		else if(typeBit == 3)
		begin
			type = "/";
		end
		tState=3;
		if(column2 != 0)
		  begin
		    temp = column2;
		    column2 = column1;
		    column1 = temp;
      end
    if(row3 == "0" && row2 != "0")
      begin
        temp = row2;
		    row2 = row1;
		    row1 = temp;  
      end
    if(row2 != "0" && row3 != "0")
      begin
        temp = row3;
		    row3 = row1;
		    row1 = temp; 
      end
	  end
	 end
	
endmodule



/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////



module test();
	wire [7:0] rx_data;
	wire [7:0] rx_data2;
	wire rx_finish;

	reg clock = 0;
	reg reset = 0;	

	reg [7:0]tx_data = 0; 
	reg [7:0]tx_data2 = 0;
	reg startSend = 0; reg startSend2 = 0;
  
	uart u1(tx2, tx_data, startSend, tx1, rx_data, rx_finish, tx_done, clock, reset);
	uart u2(tx1, tx_data2, startSend2, tx2, rx_data2, rx_finish2, tx_done2, clock, reset);
	always
	begin
		#1 clock = ~clock;
	end

	initial		// testing tx
	begin
		reset = 1;
		#1 reset = 0;
		tx_data = 27;
		tx_data2 = 31;
		#12 startSend = 1;
		#1 startSend2=1;
		#4 startSend = 0;
		startSend2=0;
	end


/*	initial		//testing rx
	begin
		#5 rx = 1;
		#20 rx = 0;
		#20 rx = 1;
		#20 rx = 0;
		#20 rx = 1;
		#20 rx = 0;
		#20 rx = 1;
		#20 rx = 1;
		#20 rx = 0;
		#20 rx = 0;
		#20 rx = 1;

		#60 rx = 0;
		#20 rx = 1;
		#20 rx = 0;
		#20 rx = 1;
		#20 rx = 0;
		#20 rx = 1;
		#20 rx = 0;
		#20 rx = 1;
	end*/
endmodule


module testTrc();
	reg [21:0] moveIn = 22'b0000000000_0000000000_10;
	
	reg start_transmit,reset;
	wire tx;
	reg clock;
	wire color;
	wire [21:0] moveOut;
	reg rx; 
	wire startGame;	
	
	tranceiver t1(startGame, tx, moveOut, endReceive, color, rx, moveIn, start_transmit, clock , reset);
		
	initial
	begin
		clock = 0;
		reset = 1;
		#5 reset = 0;
		
		
		rx = 0;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 1;
		
#20 rx = 0;
		

#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 1;
		
		///

#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 1;
		
#20 rx = 1;
		
#20 rx = 0;
		

#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 1;
		
		/////
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 1;
		

#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 1;
		
		/////
		
#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
		
#20 rx = 0;
		
#20 rx = 1;

#20 rx = 0;

#20 rx = 1;

    /////
		
#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 1;
		
#20 rx = 1;
		
		
#20 rx = 0;

#20 rx = 0;

#20 rx = 1;

    ////
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 1;

#20 rx = 1;

#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 1;

    ////
		
#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 1;
		
#20 rx = 1;
		
#20 rx = 1;

#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 1;

    ////
		
#20 rx = 0;		
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 1;
		

#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;		
		
#20 rx = 1;
				
#100 rx = 1'b1;

start_transmit = 1;

	end

	always
	begin
		#1 clock = ~clock;
	end
	   

endmodule







