`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input   	clk;
input   	reset;
output  reg [13:0] 	gray_addr;
output  reg      	gray_req;
input   	    gray_ready;
input   [7:0] 	gray_data;
output  reg [13:0] 	lbp_addr;
output  reg 	lbp_valid;
output  reg [7:0] 	lbp_data;
output  reg 	finish;
//====================================================================
parameter   IDLE = 0,
            R0   = 1,
            R1   = 2,
            R2   = 3,
            R3   = 4,
            R4   = 5,
            R5   = 6,
            R6   = 7,
            R7   = 8,
            R8   = 9,
            R9   = 10,
            WRITE = 11,
            DONE = 12;

//define cs,ns;
reg [12:0] cs,ns; 
///
reg [13:0] g4_addr;
wire [13:0] g0_addr;
wire [13:0] g1_addr;
wire [13:0] g2_addr;
wire [13:0] g3_addr;
wire [13:0] g5_addr;
wire [13:0] g6_addr;
wire [13:0] g7_addr;
wire [13:0] g8_addr;

/// address for kernel right now
// center of kernel is g4_addr
assign g0_addr = g4_addr - 14'd129;
assign g1_addr = g4_addr - 14'd128;
assign g2_addr = g4_addr - 14'd127;
assign g3_addr = g4_addr - 14'd1;
assign g5_addr = g4_addr + 14'b1;
assign g6_addr = g4_addr + 14'd127;
assign g7_addr = g4_addr + 14'd128;
assign g8_addr = g4_addr + 14'd129;

// L B P /////////////////////////////////////
// kernel size 3*3
reg [7:0] g0;
reg [7:0] g1;
reg [7:0] g2;
reg [7:0] g3;
reg [7:0] g4;
reg [7:0] g5;
reg [7:0] g6;
reg [7:0] g7;
reg [7:0] g8;

// define wire compare with center
wire comp_g0;
wire comp_g1;
wire comp_g2;
wire comp_g3;
wire comp_g5;
wire comp_g6;
wire comp_g7;
wire comp_g8;

//kernel out;
wire [7:0] k_out; // which means kernel out;
 
//define count row
reg [6:0] cnt;

//output enable
reg o_en;

// compare LBP
assign comp_g0 = (g0>=g4)? 1'b1:1'b0;
assign comp_g1 = (g1>=g4)? 1'b1:1'b0;
assign comp_g2 = (g2>=g4)? 1'b1:1'b0;
assign comp_g3 = (g3>=g4)? 1'b1:1'b0;
assign comp_g5 = (g5>=g4)? 1'b1:1'b0;
assign comp_g6 = (g6>=g4)? 1'b1:1'b0;
assign comp_g7 = (g7>=g4)? 1'b1:1'b0;
assign comp_g8 = (g8>=g4)? 1'b1:1'b0;

// LBP kernel calculate
assign k_out = {comp_g8,comp_g7,comp_g6,comp_g5,comp_g3,comp_g2,comp_g1,comp_g0};

// L B P //////////////////////////////////////

//current state logic
always@(posedge clk or posedge reset)begin
    if(reset) begin
        cs <= 13'd1;
    end
    else cs <= ns;
end

//next state logic
always@(*)begin
    ns = 13'd0;
    case(1'b1) 
        cs[IDLE]: ns[R0] = 1'b1;
        cs[R0]:begin
            if(gray_ready) ns[R1] = 1'b1;
            else ns[R0] = 1'b1;
        end
        cs[R1]:begin
            if(gray_ready) ns[R2] = 1'b1;
            else ns[R1] = 1'b1;
        end
        cs[R2]:begin
            if(gray_ready) ns[R3] = 1'b1;
            else ns[R2] = 1'b1;
        end
        cs[R3]:begin
            if(gray_ready) ns[R4] = 1'b1;
            else ns[R3] = 1'b1;
        end
        cs[R4]:begin
            if(gray_ready) ns[R5] = 1'b1;
            else ns[R4] = 1'b1;
        end
        cs[R5]:begin
            if(gray_ready) ns[R6] = 1'b1;
            else ns[R5] = 1'b1;
        end
        cs[R6]:begin
            if(gray_ready) ns[R7] = 1'b1;
            else ns[R6] = 1'b1;
        end
        cs[R7]:begin
            if(gray_ready) ns[R8] = 1'b1;
            else ns[R7] = 1'b1;
        end
        cs[R8]:begin
            if(gray_ready) ns[R9] = 1'b1;
            else ns[R8] = 1'b1;
        end
        cs[R9]: ns[WRITE] = 1'b1;
        cs[WRITE]:begin
            if(o_en) ns[DONE] = 1'b1;            
            else ns[R0] = 1'b1;
        end
		  default:begin
				ns[R0] = 1'b1;
		  end
    endcase
end

always@(posedge clk or posedge reset)begin
    if(reset)begin
        finish <= 1'b0;
        gray_addr <= 14'd0;
        gray_req <= 1'b0;
        lbp_addr <= 14'd0;
        lbp_valid <= 1'b0;
        lbp_data <= 8'd0;
        g4_addr <= 14'd129;
        cnt <= 7'b0;
        o_en <= 1'b0;
        g0 <= 8'd0;
        g1 <= 8'd0;
        g2 <= 8'd0;
        g3 <= 8'd0;
        g4 <= 8'd0;
        g5 <= 8'd0;
        g6 <= 8'd0;
        g7 <= 8'd0;
        g8 <= 8'd0;
    end
    else begin 
		case(1'b1) 
        cs[IDLE]:begin
            finish <= 1'b0;
            lbp_valid <= 1'b0;
            g4_addr <= 14'd129;
            gray_req <= 1'b0;
            cnt <= 7'b0;
        end
        cs[R0]:begin
            gray_req <= 1'b1;
            gray_addr <= g0_addr;
            lbp_valid <= 1'b0;
            finish <= 1'b0;
        end
        cs[R1]:begin
            gray_addr <= g1_addr;
            g0 <= gray_data;
        end
        cs[R2]:begin
            gray_addr <= g2_addr;
            g1 <= gray_data;
        end
        cs[R3]:begin
            gray_addr <= g3_addr;
            g2 <= gray_data;
        end
        cs[R4]:begin
            gray_addr <= g4_addr;
            g3 <= gray_data;
        end
        cs[R5]:begin
            gray_addr <= g5_addr;
            g4 <= gray_data;
        end
        cs[R6]:begin
            gray_addr <= g6_addr;
            g5 <= gray_data;
        end
        cs[R7]:begin
            gray_addr <= g7_addr;
            g6 <= gray_data;
        end
        cs[R8]:begin
            gray_addr <= g8_addr;
            g7 <= gray_data;
        end
        cs[R9]:begin
            g8 <= gray_data;
        end
        cs[WRITE]:begin
            gray_req <= 1'b0;
            lbp_addr <= g4_addr;
            lbp_valid <= 1'b1;
            lbp_data <= k_out;
            o_en <= (g4_addr == 14'd16253)? 1'b1:1'b0;
            if(cnt == 7'd125)begin
                g4_addr <= g4_addr + 7'd3;
                cnt <= 7'd0;
            end
            else begin
                g4_addr <= g4_addr + 7'd1;
                cnt <= cnt + 1'b1;
            end
        end
        cs[DONE]:begin
            gray_req <= 1'b0;
            lbp_valid <= 1'b0;
            finish <= 1'b1;
        end
    endcase
	 end
end

//====================================================================


endmodule
