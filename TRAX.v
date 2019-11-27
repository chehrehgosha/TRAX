module TRAX(rx,tx, clock, reset);
	parameter N=20;
	reg [5:0] up1 = 22;
	reg [5:0] up2 = 41;
	reg [5:0] down1  =  26;
	reg [5:0] down2 = 37;
	reg [5:0] right1 = 42;
	reg [5:0] right2 = 21;
	reg [5:0] left1 = 38;
	reg [5:0] left2 = 25;
	reg [9:0]tenone = 10'b1111111111;
	reg [2:0]khune;
	reg [2:0]khune1;
	reg [2:0]khune2;
	reg [2:0]khune3;
	input rx;
	output wire tx;
	reg start_transmit;
	input clock, reset;
	reg [21:0] move_in;
	wire [21:0] move_out;
	reg [19:0] counter;
	reg [5:0] sixone;
	tranceiver t1(startGame, tx, move_out, end_receive, color, rx, move_in, start_transmit, clock, reset);
	reg [2:0] jadval[999:0][702:0];
	reg [21:0] harekat1 [39:0];
	reg [2:0] harekat2 [39:0];
	reg [9:0] row;
	reg [9:0] column;
	reg [1:0] type;
	reg done;
	reg [3:0] state;
	reg tclock=0;
	reg flag = 0;
	genvar jj;
	genvar ii;

  
	generate
		for(ii=0;ii<N;ii=ii+1) begin: ii_loop			//khalid kardane hameye khuneha ye sefr kardaneshun
			for(jj=0;jj<N;jj=jj+1) begin: jj_loop
				initial
					jadval[ii][jj]=3'b000;
			end
		end
	endgenerate
	
	reg [4:0]i=0;
	reg [4:0]j=0;
	reg k;
	always @(posedge clock)begin
	  if(color == 1) begin
		  move_in <= 22'b0000000000000000000001;
		  start_transmit <= 1;
		end
	end
	always @(posedge clock)begin				//state shomare 0,gereftane harekat va zakhire an tuye jadval state 0
	 if (end_receive ==1)begin
		if(jadval[5][6] == 0) flag = 1;
		start_transmit<=0;
		row<=move_out[21:12];					//gereftane satre harekate morede nazar
		column<=move_out[11:2];					//gereftne sotun
		type<=move_out[1:0];
		if (jadval[row][column-1]!=0)begin			//barresi khaney samte chap
			if (type==1)begin				
				case (jadval[row][column-1])
					1:jadval[row][column]<=2;
					2:jadval[row][column]<=1;
					3:jadval[row][column]<=2;
					4:jadval[row][column]<=1;
					5:jadval[row][column]<=2;
					6:jadval[row][column]<=1;
				endcase
			end
			else if (type==2)begin
				case (jadval[row][column-1])
					1:jadval[row][column]<=3;
					2:jadval[row][column]<=4;
					3:jadval[row][column]<=3;
					4:jadval[row][column]<=4;
					5:jadval[row][column]<=3;
					6:jadval[row][column]<=4;
				endcase
			end
			else if (type==3)begin
				case (jadval[row][column-1])
					1:jadval[row][column]<=6;
					2:jadval[row][column]<=5;
					3:jadval[row][column]<=6;
					4:jadval[row][column]<=5;
					5:jadval[row][column]<=6;
					6:jadval[row][column]<=5;
				endcase
			end
		end
		else if (jadval[row][column+1]!=0)begin			//barresi khuneye rast
			if (type==1)begin
				case (jadval[row][column+1])
					1:jadval[row][column]<=2;
					2:jadval[row][column]<=1;
					3:jadval[row][column]<=1;
					4:jadval[row][column]<=2;
					5:jadval[row][column]<=2;
					6:jadval[row][column]<=1;
				endcase
			end
			else if(type==2)begin
				case (jadval[row][column+1])
					1:jadval[row][column]<=4;
					2:jadval[row][column]<=3;
					3:jadval[row][column]<=3;
					4:jadval[row][column]<=4;
					5:jadval[row][column]<=4;
					6:jadval[row][column]<=3;
				endcase
			end
			else if (type==3)begin
				case (jadval[row][column+1])
					1:jadval[row][column]<=6;
					2:jadval[row][column]<=5;
					3:jadval[row][column]<=5;
					4:jadval[row][column]<=6;
					5:jadval[row][column]<=6;
					6:jadval[row][column]<=5;
				endcase
			end
		end
		else if (jadval[row-1][column]!=0)begin			//barresi khuneye bala
			if (type==1)begin
				case (jadval[row-1][column])
					1:jadval[row][column]<=2;
					2:jadval[row][column]<=1;
					3:jadval[row][column]<=2;
					4:jadval[row][column]<=1;
					5:jadval[row][column]<=1;
					6:jadval[row][column]<=2;
				endcase
			end
			else if(type==2)begin
				case (jadval[row-1][column])
					1:jadval[row][column]<=3;
					2:jadval[row][column]<=4;
					3:jadval[row][column]<=3;
					4:jadval[row][column]<=4;
					5:jadval[row][column]<=4;
					6:jadval[row][column]<=3;
				endcase
			end
			else if (type==3)begin
				case (jadval[row-1][column])
					1:jadval[row][column]<=5;
					2:jadval[row][column]<=6;
					3:jadval[row][column]<=5;
					4:jadval[row][column]<=6;
					5:jadval[row][column]<=6;
					6:jadval[row][column]<=5;
				endcase
			end
		end
		else if (jadval[row+1][column]!=0)begin			//barresi khuneye payin
			if (type==1)begin
				case (jadval[row+1][column])
					1:jadval[row][column]<=2;
					2:jadval[row][column]<=1;
					3:jadval[row][column]<=1;
					4:jadval[row][column]<=2;
					5:jadval[row][column]<=1;
					6:jadval[row][column]<=2;
				endcase
			end
			else if(type==2)begin
				case (jadval[row+1][column])
					1:jadval[row][column]<=4;
					2:jadval[row][column]<=3;
					3:jadval[row][column]<=3;
					4:jadval[row][column]<=4;
					5:jadval[row][column]<=3;
					6:jadval[row][column]<=4;
				endcase
			end
			else if (type==3)begin
				case (jadval[row+1][column])
					1:jadval[row][column]<=5;
					2:jadval[row][column]<=6;
					3:jadval[row][column]<=6;
					4:jadval[row][column]<=5;
					5:jadval[row][column]<=6;
					6:jadval[row][column]<=5;
				endcase
			end
		end
		else begin
		  if (type==2)begin
		    jadval[row][column]=3;
		  end
		  else begin
		    jadval[row][column]=5;
		   end
		 end
		khune=jadval[0][0];
		state <= 3'b001;
		i <=N;
		j <=N;
		tclock<=~tclock;
	end
end
	always @(posedge clock)begin						//barresi shift bala va shift e rast state 1
	if (tclock==1)begin
		if (state == 1)begin
		  khune=jadval[0][0];
			if (row == 0)begin
				jadval[i][j]<=jadval[i-1][j];
				if (i==1)begin
					if(j==1)begin
						i<=0;
						j<=0;
						state<=10;
						done<=1;
						tclock<=~tclock;
					end
				end
				else if (j==0)begin
					i<=i-1;
					j<=N;
					tclock<=~tclock;
				end
				else begin
					j<=j-1;
					tclock<=~tclock;
				end
			end
			if (column == 0)begin
				jadval[i][j]<=jadval[i][j-1];
				if (i==1)begin
					if(j==1)begin
						i<=0;
						j<=0;
						done<=1;
						state<=10;
						tclock<=~tclock;
					end
				end
				else if (i==0)begin
					j<=j-1;
					i<=N;
					tclock<=~tclock;
				end
				else begin
					i<=i-1;
					tclock<=~tclock;
				end
			end
		end
	end
	end
	always @(posedge clock)begin
	  if (tclock==1)begin
	    if (state==10)begin
	      if (column ==0 & row == 0 )begin
	        jadval[1][1]=jadval[0][0];
	       end
	       state<=8;
	       tclock<=~tclock;
	     end
	   end
	 end
	always @(posedge clock)begin
	  if (tclock==1)begin
	    if (state==8)begin
	      khune=jadval[0][0];
	      khune1=jadval[0][1];
	      khune2=jadval[1][0];
	      khune3=jadval[1][1];
	      jadval[i][j]=0;
	      if(j==N)begin
	        state<=9;
	        j<=0;
	        tclock<=~tclock;
	      end
	      else begin
	        j<=j+1;
	        tclock<=~tclock;
	      end
	    end
	  end
	 end
	 
	 always @(posedge clock)begin
	  if (tclock==1)begin
	    if (state==9)begin
	      jadval[i][j]=0;
	      if(i==N)begin
	        state<=2;
	        i<=0;
	        tclock<=~tclock;
	      end
	      else begin
	        i<=i+1;
	        tclock<=~tclock;
	      end
	    end
	  end
	 end
	 
	always @(posedge clock)begin						//barresi harekat ejbari state 2
	if(tclock==1)begin
		if (state == 2)begin
			if(done==1)begin
					if(jadval[i][j-1]==1)begin			//check kardane chap va bala
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin			//check kardane chap va rast
						if(jadval[i][j+1]==2)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i][j+1]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i][j+1]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i][j+1]==2)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i][j+1]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i][j+1]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i][j+1]==2)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i][j+1]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i][j+1]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin			//check kardane chap va payin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin			//check kardane rast va payin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin			//check kardane rast va bala
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i+1][j]==1)begin			//check kardane payin va bala
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==1)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==1)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==4)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==4)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==4)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==6)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==6)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==6)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
												//yet for white
					if(jadval[i][j-1]==2)begin			//check kardane chap va bala
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin			//check kardane chap va rast
						if(jadval[i][j+1]==1)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i][j+1]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i][j+1]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i][j+1]==1)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i][j+1]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i][j+1]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i][j+1]==1)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i][j+1]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i][j+1]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin			//check kardane chap va payin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==1)begin			//check kardane rast va payin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==1)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==1)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==1)begin			//check kardane rast va bala
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==1)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i+1][j]==2)begin			//check kardane payin va bala
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==2)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==2)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==3)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==3)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==3)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==5)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==5)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==5)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if (j==N)begin
						if(i==N)begin
							if(done==1)begin
								state<=3'b011;
								i<=0;
								j<=0;
								counter<=0;
								tclock<=~tclock;
							end
							else begin
								i<=0;
								j<=0;
								done<=1;
								tclock<=~tclock;
							end
						end
						else begin
							i<=i+1;
							j<=0;
							tclock<=~tclock;
							done<=1;
						end
					end
					else begin
						j<=j+1;
						tclock<=~tclock;
						done<=1;
					end
			end
		end
	end
	end
	
	always @(posedge clock)begin
	  if  (tclock==0)begin
	    tclock=~tclock;
	    end
	 end
	
	always @(posedge clock)begin						//barresi e harekat haye mojud state 3
		if(tclock == 1) begin
		if (state==3)begin
			sixone=6'b111111;
			if (jadval[i][j]==0)begin
				case (jadval[i-1][j]) //bala
					1:sixone<=sixone&up1;
					2:sixone=sixone&up2;
					3:sixone=sixone&up1;
					4:sixone=sixone&up2;
					5:sixone=sixone&up2;
					6:sixone=sixone&up1;
				endcase
				case (jadval[i+1][j]) //payin//
					1:sixone=sixone&down1;
					2:sixone=sixone&down2;
					3:sixone=sixone&down2;
					4:sixone=sixone&down1;
					5:sixone=sixone&down2;
					6:sixone=sixone&down1;
				endcase
				case (jadval[i][j+1]) //rast//
					1:sixone=sixone&right1;
					2:sixone=sixone&right2;
					3:sixone=sixone&right2;
					4:sixone=sixone&right1;
					5:sixone=sixone&right1;
					6:sixone=sixone&right2;
				endcase
				case (jadval[i][j-1]) //chap//
					1:sixone=sixone&left1;
					2:sixone=sixone&left2;
					3:sixone=sixone&left1;
					4:sixone=sixone&left2;
					5:sixone=sixone&left1;
					6:sixone=sixone&left2;
				endcase
			end
			if (sixone!=6'b111111)begin
				if(sixone&100000>0)begin
					harekat1[counter][21:12]<=j;
					harekat1[counter][11:2]<=i;
					harekat1[counter][1:0]<=2'b01;
					harekat2[counter]<=1;
					counter=counter+1;
				end
				if(sixone&010000>0)begin
					harekat1[counter][21:12]<=j;
					harekat1[counter][11:2]<=i;
					harekat1[counter][1:0]<=2'b01;
					harekat2[counter]<=2;	
					counter=counter+1;
				end
				if(sixone&001000>0)begin
					harekat1[counter][21:12]<=j;
					harekat1[counter][11:2]<=i;
					harekat1[counter][1:0]<=2'b10;
					harekat2[counter]<=3;
					counter=counter+1;
				end
				if(sixone&000100>0)begin
					harekat1[counter][21:12]<=j;
					harekat1[counter][11:2]<=i;
					harekat1[counter][1:0]<=2'b10;
					harekat2[counter]<=4;
					counter=counter+1;
				end
				if(sixone&000010>0)begin
					harekat1[counter][21:12]<=j;
					harekat1[counter][11:2]<=i;
					harekat1[counter][1:0]<=2'b11;
					harekat2[counter]<=5;
					counter=counter+1;
				end
				if(sixone&000001>0)begin
					harekat1[counter][21:12]<=j;
					harekat1[counter][11:2]<=i;
					harekat1[counter][1:0]<=2'b11;
					harekat2[counter]<=6;
					counter=counter+1;
				end
				
			end
			if (counter==39)begin
				state<=3'b100;
				tclock<=~tclock;
			end
			if (j==N)begin
				if(i==N)begin
					state<=3'b100;
					tclock<=!tclock;
				end
				else begin
					j<=0;
					i<=i+1;
					tclock<=~tclock;
				end
			end
			else begin
				j<=j+1;
				tclock<=~tclock;
			end
		end
		end
	end


	always @(posedge clock)begin						//peyda kardane avalin harekat state 4
		if(tclock == 1) begin
		if (state==4)begin
			move_in<=harekat1[0];
			khune=harekat2[0];
			column<=harekat1[0][21:12];
			row<=harekat1[0][11:2];
			if(row==0)begin
				i<=N;
				j<=N;
			end
			else if(column==0)begin
				i<=N;
				j<=N;
			end
			else begin
				i<=0;
				j<=0;
			end
			state<=3'b101;
			tclock<=~tclock;
			done<=1;
		end
  end
	end
	always @(posedge clock)begin						//barresie shifte nashi az harekate khodemun state 5
		if (tclock == 1) begin
		if (state == 5)begin
			if (row == 0)begin
				jadval[i][j]<=jadval[i-1][j];
				if (i==1)begin
					if(j==1)begin
						i<=0;
						j<=0;
						state<=3'b110;
						done<=1;
						tclock<=~tclock;
					end
				end
				else if (j==0)begin
					i<=i-1;
					j<=N;
					tclock<=~tclock;
				end
				else begin
					j<=j-1;
					tclock<=~tclock;
				end
			end
			if (column == 0)begin
				jadval[i][j]<=jadval[i][j-1];
				if (i==1)begin
					if(j==1)begin
						i<=0;
						j<=0;
						done<=1;
						state<=3'b110;
						tclock<=~tclock;
					end
				end
				else if (i==0)begin
					j<=j-1;
					i<=N;
					tclock<=~tclock;
				end
				else begin
					i<=i-1;
					tclock<=~tclock;
				end
			end
			else begin
				state<=3'b110;
				tclock<=~tclock;
			end
		end
		end
	end
	always @(posedge clock)begin						//barresie harekat ejbari nashi az harekate khodemun 6
		if(tclock == 1) begin
		if (state==6)begin
			if(done==1)begin
					if(jadval[i][j-1]==1)begin			//check kardane chap va bala
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin			//check kardane chap va rast
						if(jadval[i][j+1]==2)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i][j+1]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i][j+1]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i][j+1]==2)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i][j+1]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i][j+1]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i][j+1]==2)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i][j+1]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i][j+1]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin			//check kardane chap va payin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==1)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==3)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j-1]==5)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin			//check kardane rast va payin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i+1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i+1][j]==4)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i+1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin			//check kardane rast va bala
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==3)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==6)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i+1][j]==1)begin			//check kardane payin va bala
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==1)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==1)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==4)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==4)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==4)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==6)begin
						if(jadval[i-1][j]==2)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==6)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i+1][j]==6)begin
						if(jadval[i-1][j]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
												//yet for white
					if(jadval[i][j-1]==2)begin			//check kardane chap va bala
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=5;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin			//check kardane chap va rast
						if(jadval[i][j+1]==1)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i][j+1]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i][j+1]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i][j+1]==1)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i][j+1]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i][j+1]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i][j+1]==1)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i][j+1]==4)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i][j+1]==5)begin
							jadval[i][j]<=4;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin			//check kardane chap va payin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==2)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==4)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j-1]==6)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==1)begin			//check kardane rast va payin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==1)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==1)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i+1][j]==2)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i+1][j]==3)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i+1][j]==5)begin
							jadval[i][j]<=6;
							done<=0;
						end
					end
					if(jadval[i][j+1]==1)begin			//check kardane rast va bala
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==2)begin
						if(jadval[i-1][j]==4)begin
							jadval[i][j]<=1;
							done<=0;
						end
					end
					if(jadval[i][j+1]==1)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==4)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i][j+1]==5)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=2;
							done<=0;
						end
					end
					if(jadval[i+1][j]==2)begin			//check kardane payin va bala
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==2)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==2)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==3)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==3)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==3)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==5)begin
						if(jadval[i-1][j]==1)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==5)begin
						if(jadval[i-1][j]==3)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if(jadval[i+1][j]==5)begin
						if(jadval[i-1][j]==6)begin
							jadval[i][j]<=3;
							done<=0;
						end
					end
					if (j==N)begin
						if(i==N)begin
							if(done==1)begin
								state<=3'b111;
								i<=0;
								j<=0;
								counter<=0;
								tclock<=~tclock;
							end
							else begin
								i<=0;
								j<=0;
								done<=1;
								tclock<=~tclock;
							end
						end
						else begin
							i<=i+1;
							j<=0;
							tclock<=~tclock;
							done<=1;
						end
					end
					else begin
						j<=j+1;
						tclock<=~tclock;
						done<=1;
					end
			end
		end
		end
end
		
		
			

	always @(clock)begin
	 if(tclock==1)begin
		if (state==7)begin
			start_transmit<=1;
			state<=0;
		end
	end
	end
endmodule

	
module trax_tb();
  
  reg rx, clock, reset;
  wire tx;
  
  TRAX ttt1(rx, tx, clock, reset);
  
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
		
#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 0;
		

#20 rx = 0;
		
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
		
		
		
		
#20		rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		

#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 1;
		
		///

#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 0;
		

#20 rx = 1;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 0;
		
#20 rx = 1;
		
		/////
		
#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 1;
		
#20 rx = 0;
		
#20 rx = 1;
		

#20 rx = 0;
		
#20 rx = 1;
		
#20 rx = 0;
		
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
/*
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
		
*/		
		
#100 rx = 1'bz;
	end

	always
	begin
		#1 clock = ~clock;
	end
  
  


endmodule

