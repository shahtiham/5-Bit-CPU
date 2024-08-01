module FA(
    input wire faA,
    input wire faB,
    input wire faCin,

    output wire faCout,
    output wire faS
);
    assign faS = faA^faB^faCin;
    assign faCout = ((faA^faB)&faCin)|(faA&faB);

endmodule

module ADD(
    input wire [4:0] A,
    input wire [4:0] B,
    input wire Cin,
    
    output wire Cout,
    output wire [4:0] R
);
    wire [4:0] c;

    FA fa0(.faA(A[0]),.faB(B[0]),.faCin(Cin),.faCout(c[0]),.faS(R[0]));
    FA fa1(.faA(A[1]),.faB(B[1]),.faCin(c[0]),.faCout(c[1]),.faS(R[1]));
    FA fa2(.faA(A[2]),.faB(B[2]),.faCin(c[1]),.faCout(c[2]),.faS(R[2]));
    FA fa3(.faA(A[3]),.faB(B[3]),.faCin(c[2]),.faCout(c[3]),.faS(R[3]));
    FA fa4(.faA(A[4]),.faB(B[4]),.faCin(c[3]),.faCout(Cout),.faS(R[4]));
    
endmodule

module OR(
    input wire [4:0] A,
    input wire [4:0] B,

    output wire [4:0] R
);
    assign R = A | B;
endmodule

module B1T32TO1MUX(
    input wire [31:0] b1t32to1mux,
    input wire [4:0] b1t32to1muxSEL,

    output wire b1t32to1muxO
);
    reg o;
    always @(*) begin
        if     (b1t32to1muxSEL == 5'b00000) o = b1t32to1mux[0];
        else if(b1t32to1muxSEL == 5'b00001) o = b1t32to1mux[1];
        else if(b1t32to1muxSEL == 5'b00010) o = b1t32to1mux[2];
        else if(b1t32to1muxSEL == 5'b00011) o = b1t32to1mux[3];
        else if(b1t32to1muxSEL == 5'b00100) o = b1t32to1mux[4];
        else if(b1t32to1muxSEL == 5'b00101) o = b1t32to1mux[5];
        else if(b1t32to1muxSEL == 5'b00110) o = b1t32to1mux[6];
        else if(b1t32to1muxSEL == 5'b00111) o = b1t32to1mux[7];
        else if(b1t32to1muxSEL == 5'b01000) o = b1t32to1mux[8];
        else if(b1t32to1muxSEL == 5'b01001) o = b1t32to1mux[9];
        else if(b1t32to1muxSEL == 5'b01010) o = b1t32to1mux[10];
        else if(b1t32to1muxSEL == 5'b01011) o = b1t32to1mux[11];
        else if(b1t32to1muxSEL == 5'b01100) o = b1t32to1mux[12];
        else if(b1t32to1muxSEL == 5'b01101) o = b1t32to1mux[13];
        else if(b1t32to1muxSEL == 5'b01110) o = b1t32to1mux[14];
        else if(b1t32to1muxSEL == 5'b01111) o = b1t32to1mux[15];
        else if(b1t32to1muxSEL == 5'b10000) o = b1t32to1mux[16];
        else if(b1t32to1muxSEL == 5'b10001) o = b1t32to1mux[17];
        else if(b1t32to1muxSEL == 5'b10010) o = b1t32to1mux[18];
        else if(b1t32to1muxSEL == 5'b10011) o = b1t32to1mux[19];
        else if(b1t32to1muxSEL == 5'b10100) o = b1t32to1mux[20];
        else if(b1t32to1muxSEL == 5'b10101) o = b1t32to1mux[21];
        else if(b1t32to1muxSEL == 5'b10110) o = b1t32to1mux[22];
        else if(b1t32to1muxSEL == 5'b10111) o = b1t32to1mux[23];
        else if(b1t32to1muxSEL == 5'b11000) o = b1t32to1mux[24];
        else if(b1t32to1muxSEL == 5'b11001) o = b1t32to1mux[25];
        else if(b1t32to1muxSEL == 5'b11010) o = b1t32to1mux[26];
        else if(b1t32to1muxSEL == 5'b11011) o = b1t32to1mux[27];
        else if(b1t32to1muxSEL == 5'b11100) o = b1t32to1mux[28];
        else if(b1t32to1muxSEL == 5'b11101) o = b1t32to1mux[29];
        else if(b1t32to1muxSEL == 5'b11110) o = b1t32to1mux[30];
        else if(b1t32to1muxSEL == 5'b11111) o = b1t32to1mux[31];
        else                                o = 0;
    end

    assign b1t32to1muxO = o;

endmodule

module SHL(
    input wire [4:0] A,
    input wire [4:0] B,

    output wire [4:0] R
);
    B1T32TO1MUX m0(.b1t32to1mux({31'b0000000000000000000000000000000,A[0]}),.b1t32to1muxSEL(B),.b1t32to1muxO(R[0]));
    B1T32TO1MUX m1(.b1t32to1mux({30'b000000000000000000000000000000,A[0],A[1]}),.b1t32to1muxSEL(B),.b1t32to1muxO(R[1]));
    B1T32TO1MUX m2(.b1t32to1mux({29'b00000000000000000000000000000,A[0],A[1],A[2]}),.b1t32to1muxSEL(B),.b1t32to1muxO(R[2]));
    B1T32TO1MUX m3(.b1t32to1mux({28'b0000000000000000000000000000,A[0],A[1],A[2],A[3]}),.b1t32to1muxSEL(B),.b1t32to1muxO(R[3]));
    B1T32TO1MUX m4(.b1t32to1mux({27'b000000000000000000000000000,A[0],A[1],A[2],A[3],A[4]}),.b1t32to1muxSEL(B),.b1t32to1muxO(R[4]));
    
endmodule

module B5T4TO1MUX(
    input wire [4:0] b5t4to1mux0,
    input wire [4:0] b5t4to1mux1,
    input wire [4:0] b5t4to1mux2,
    input wire [4:0] b5t4to1mux3,
    input wire [1:0] b5t4to1muxSEL,

    output wire [4:0] b5t4to1muxO
);
    reg [4:0] o;
    always @(*) begin
        if     (b5t4to1muxSEL == 2'b00) o = b5t4to1mux0;
        else if(b5t4to1muxSEL == 2'b01) o = b5t4to1mux1;
        else if(b5t4to1muxSEL == 2'b10) o = b5t4to1mux2;
        else if(b5t4to1muxSEL == 2'b11) o = b5t4to1mux3;
        else                            o = 0;
    end
    assign b5t4to1muxO = o;

endmodule

module ALU(
    input wire [4:0] A,
    input wire [4:0] B,
    input wire [1:0] OP,

    output wire SF,
    output wire ZF,
    output wire [4:0] R
);
    wire [4:0] addow;
    wire addcow;
    wire [4:0] orow;
    wire [4:0] shlow;

    reg b1gnd = 0;
    reg [4:0] b5gnd = 5'b00000;

    ADD add(.A(A), .B(B), .Cin(b1gnd), .Cout(addcow), .R(addow));
    OR orr(.A(A), .B(B), .R(orow));
    SHL shl(.A(A), .B(B), .R(shlow));

    B5T4TO1MUX mux(.b5t4to1mux0(addow), .b5t4to1mux1(orow), .b5t4to1mux2(shlow), .b5t4to1mux3(b5gnd), .b5t4to1muxSEL(OP), .b5t4to1muxO(R));

    assign SF = R[4];
    assign ZF = ~ (R[4] | R[3] | R[2] | R[1] | R[0]);

endmodule