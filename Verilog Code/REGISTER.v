module DFLIPFLOP(
    input wire dflipflopC,
    input wire  dflipflopD,

    output wire dflipflopQ
);
    reg d = 0;
    always @(posedge dflipflopC) begin
        d <= dflipflopD;
    end
    assign dflipflopQ = d;

endmodule

module B1T2TO1MUX(
    input wire b1t2to1mux0,
    input wire b1t2to1mux1,
    input wire b1t2to1muxSEL,

    output wire b1t2to1muxO
);
    reg o ;
    always @(b1t2to1mux0 or b1t2to1mux1 or b1t2to1muxSEL) begin
        o = (b1t2to1muxSEL)?b1t2to1mux1:b1t2to1mux0;
    end
    assign b1t2to1muxO = o;

endmodule

module B1TREG(
    input wire b1tregDin,
    input wire b1tregSEL,
    input wire b1tregCLK,
    
    output wire b1tregDout
);
    wire muxtofp;

    B1T2TO1MUX mux(
        .b1t2to1mux0(b1tregDout),
        .b1t2to1mux1(b1tregDin),
        .b1t2to1muxSEL(b1tregSEL),
        .b1t2to1muxO(muxtofp)
    );

    DFLIPFLOP df(
        .dflipflopC(b1tregCLK),
        .dflipflopD(muxtofp),
        .dflipflopQ(b1tregDout)
    );

endmodule

module B5TREG(
    input wire [4:0] b5tregDin,
    input wire b5tregSEL,
    input wire b5tregCLK,
    
    output wire [4:0] b5tregDout
);
    B1TREG b1treg0(.b1tregDin(b5tregDin[0]),.b1tregSEL(b5tregSEL),.b1tregCLK(b5tregCLK),.b1tregDout(b5tregDout[0]));
    B1TREG b1treg1(.b1tregDin(b5tregDin[1]),.b1tregSEL(b5tregSEL),.b1tregCLK(b5tregCLK),.b1tregDout(b5tregDout[1]));
    B1TREG b1treg2(.b1tregDin(b5tregDin[2]),.b1tregSEL(b5tregSEL),.b1tregCLK(b5tregCLK),.b1tregDout(b5tregDout[2]));
    B1TREG b1treg3(.b1tregDin(b5tregDin[3]),.b1tregSEL(b5tregSEL),.b1tregCLK(b5tregCLK),.b1tregDout(b5tregDout[3]));
    B1TREG b1treg4(.b1tregDin(b5tregDin[4]),.b1tregSEL(b5tregSEL),.b1tregCLK(b5tregCLK),.b1tregDout(b5tregDout[4]));

endmodule

module B3TO8DECODER(
    input wire [2:0] b3to8decoderS,

    output wire [7:0] b3to8decoderO
);
    reg [7:0] dout;
    always @(b3to8decoderS) begin
        if     (b3to8decoderS == 3'b000)dout = 8'b00000001;
        else if(b3to8decoderS == 3'b001)dout = 8'b00000010;
        else if(b3to8decoderS == 3'b010)dout = 8'b00000100;
        else if(b3to8decoderS == 3'b011)dout = 8'b00001000;
        else if(b3to8decoderS == 3'b100)dout = 8'b00010000;
        else if(b3to8decoderS == 3'b101)dout = 8'b00100000;
        else if(b3to8decoderS == 3'b110)dout = 8'b01000000;
        else if(b3to8decoderS == 3'b111)dout = 8'b10000000;
        else                            dout = 8'b00000000;
    end
    
    assign b3to8decoderO = dout;
endmodule

module B5T8TO1MUX(
    input wire [4:0] b5t8to1mux0,
    input wire [4:0] b5t8to1mux1,
    input wire [4:0] b5t8to1mux2,
    input wire [4:0] b5t8to1mux3,
    input wire [4:0] b5t8to1mux4,
    input wire [4:0] b5t8to1mux5,
    input wire [4:0] b5t8to1mux6,
    input wire [4:0] b5t8to1mux7,
    input wire [2:0] b5t8to1muxSEL,

    output wire [4:0] b5t8to1muxO
);
    reg  [4:0] o ;
    always @(b5t8to1mux0 or b5t8to1mux1 or b5t8to1mux2 or b5t8to1mux3 or b5t8to1mux4 or b5t8to1mux5 or b5t8to1mux6 or b5t8to1mux7 or b5t8to1muxSEL) begin
        if     (b5t8to1muxSEL == 3'b000)o = b5t8to1mux0;
        else if(b5t8to1muxSEL == 3'b001)o = b5t8to1mux1;
        else if(b5t8to1muxSEL == 3'b010)o = b5t8to1mux2;
        else if(b5t8to1muxSEL == 3'b011)o = b5t8to1mux3;
        else if(b5t8to1muxSEL == 3'b100)o = b5t8to1mux4;
        else if(b5t8to1muxSEL == 3'b101)o = b5t8to1mux5;
        else if(b5t8to1muxSEL == 3'b110)o = b5t8to1mux6;
        else if(b5t8to1muxSEL == 3'b111)o = b5t8to1mux7;
        else                            o = 0;
    end

    assign b5t8to1muxO = o;
endmodule

module REGISTER(
    input wire [2:0] regRa,
    input wire [2:0] regRb,
    input wire [2:0] regWr,
    input wire regCLK,
    input wire regEN,
    input wire [4:0] regWRD,

    output wire [4:0] regA,
    output wire [4:0] regB,
    output wire [4:0] regO
);
    wire [7:0] wrdecw;

    wire [4:0] r1;
    wire [4:0] r2;
    wire [4:0] r3;
    wire [4:0] r4;
    wire [4:0] r5;
    wire [4:0] r6;
    reg [4:0] r7 = 5'b00000;
    reg [4:0] r8 = 5'b00000;

    reg [7:0] radecw;
    reg [7:0] rbdecw;
    reg [7:0] wrdec;

    B5T8TO1MUX da(.b5t8to1mux0(r1),.b5t8to1mux1(r2),.b5t8to1mux2(r3),.b5t8to1mux3(r4),.b5t8to1mux4(r5),.b5t8to1mux5(r6),.b5t8to1mux6(r7),.b5t8to1mux7(r8),.b5t8to1muxSEL(regRa),.b5t8to1muxO(regA));
    B5T8TO1MUX db(.b5t8to1mux0(r1),.b5t8to1mux1(r2),.b5t8to1mux2(r3),.b5t8to1mux3(r4),.b5t8to1mux4(r5),.b5t8to1mux5(r6),.b5t8to1mux6(r7),.b5t8to1mux7(r8),.b5t8to1muxSEL(regRb),.b5t8to1muxO(regB));
    
    B5T8TO1MUX dou(.b5t8to1mux0(r1),.b5t8to1mux1(r2),.b5t8to1mux2(r3),.b5t8to1mux3(r4),.b5t8to1mux4(r5),.b5t8to1mux5(r6),.b5t8to1mux6(r7),.b5t8to1mux7(r8),.b5t8to1muxSEL(regRa),.b5t8to1muxO(regO));

    B3TO8DECODER d3(.b3to8decoderS(regWr),.b3to8decoderO(wrdecw));
    
    always @(wrdecw or regEN) begin
        wrdec = (regEN)?wrdecw:8'b00000000;
    end

    B5TREG reg0(.b5tregDin(regWRD),.b5tregSEL(wrdec[0]),.b5tregCLK(regCLK),.b5tregDout(r1));
    B5TREG reg1(.b5tregDin(regWRD),.b5tregSEL(wrdec[1]),.b5tregCLK(regCLK),.b5tregDout(r2));
    B5TREG reg2(.b5tregDin(regWRD),.b5tregSEL(wrdec[2]),.b5tregCLK(regCLK),.b5tregDout(r3));
    B5TREG reg3(.b5tregDin(regWRD),.b5tregSEL(wrdec[3]),.b5tregCLK(regCLK),.b5tregDout(r4));
    B5TREG reg4(.b5tregDin(regWRD),.b5tregSEL(wrdec[4]),.b5tregCLK(regCLK),.b5tregDout(r5));
    B5TREG reg5(.b5tregDin(regWRD),.b5tregSEL(wrdec[5]),.b5tregCLK(regCLK),.b5tregDout(r6));
    
endmodule