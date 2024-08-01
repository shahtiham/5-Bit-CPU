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

module PCADDER(
    input wire [3:0] pcaI,

    output wire [3:0] pcaO
);
    wire [3:0] pcaddcout;
    reg cnst0 = 0;
    reg cnst1 = 1;

    FA fa0(
        .faA(pcaI[0]),
        .faB(cnst1),
        .faCin(cnst0),
        .faCout(pcaddcout[0]),
        .faS(pcaO[0])
    );
    FA fa1(
        .faA(pcaI[1]),
        .faB(cnst0),
        .faCin(pcaddcout[0]),
        .faCout(pcaddcout[1]),
        .faS(pcaO[1])
    );
    FA fa2(
        .faA(pcaI[2]),
        .faB(cnst0),
        .faCin(pcaddcout[1]),
        .faCout(pcaddcout[2]),
        .faS(pcaO[2])
    );
    FA fa3(
        .faA(pcaI[3]),
        .faB(cnst0),
        .faCin(pcaddcout[2]),
        .faCout(pcaddcout[3]),
        .faS(pcaO[3])
    );

endmodule

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

module B1R1RAM(
    input wire b1r1ramWD,
    input wire b1r1ramWS,
    input wire b1r1ramRS1,
    input wire b1r1ramRS2,
    input wire b1r1ramCLK,
    
    output wire b1r1ramRD1,
    output wire b1r1ramRD2
);
    wire muxtofp;
    wire fptomux;

    reg rRD1;
    reg rRD2;

    DFLIPFLOP df(
        .dflipflopC(b1r1ramCLK),
        .dflipflopD(muxtofp),
        .dflipflopQ(fptomux)
    );

    B1T2TO1MUX mux(
        .b1t2to1mux0(fptomux),
        .b1t2to1mux1(b1r1ramWD),
        .b1t2to1muxSEL(b1r1ramWS),
        .b1t2to1muxO(muxtofp)
    );

    always @(b1r1ramRS1 or fptomux) begin
        rRD1 = (b1r1ramRS1)?fptomux:0;
    end

    always @(b1r1ramRS2 or fptomux) begin
        rRD2 = (b1r1ramRS2)?fptomux:0;
    end
    
    assign b1r1ramRD1 = rRD1;
    assign b1r1ramRD2 = rRD2;
endmodule

module B1R15RAM(
    input wire b1r15ramRS1,
    input wire b1r15ramRS2,
    input wire b1r15ramWS,
    input wire [14:0] b1r15ramWD,
    input wire b1r15ramCLK,

    output wire [14:0] b1r15ramRD1,
    output wire [14:0] b1r15ramRD2
);
    /*
        OR DO THIS:
        1. Declare local wire variable and reg variable.
        2. Connect local wire variable with B1R1RAM module output.
        3. For any change in local wire, update local reg.
        4. Assign value of local reg to module wire output.
    wire [14:0] b1r15ramO;
    wire [14:0] b1r15ramO1;
    // *** USE TWO DIFFERENT WIRES TO CONNECT TO TWO OUTPUT WIRES. OTHERWISE ERROR OCCURS.

    reg [14:0] r15RD1;
    reg [14:0] r15RD2;

    */
    B1R1RAM b1r1rm0(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[0]),.b1r1ramRD1(b1r15ramRD1[0]),.b1r1ramRD2(b1r15ramRD2[0]));
    B1R1RAM b1r1rm1(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[1]),.b1r1ramRD1(b1r15ramRD1[1]),.b1r1ramRD2(b1r15ramRD2[1]));
    B1R1RAM b1r1rm2(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[2]),.b1r1ramRD1(b1r15ramRD1[2]),.b1r1ramRD2(b1r15ramRD2[2]));
    B1R1RAM b1r1rm3(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[3]),.b1r1ramRD1(b1r15ramRD1[3]),.b1r1ramRD2(b1r15ramRD2[3]));
    B1R1RAM b1r1rm4(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[4]),.b1r1ramRD1(b1r15ramRD1[4]),.b1r1ramRD2(b1r15ramRD2[4]));
    B1R1RAM b1r1rm5(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[5]),.b1r1ramRD1(b1r15ramRD1[5]),.b1r1ramRD2(b1r15ramRD2[5]));
    B1R1RAM b1r1rm6(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[6]),.b1r1ramRD1(b1r15ramRD1[6]),.b1r1ramRD2(b1r15ramRD2[6]));
    B1R1RAM b1r1rm7(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[7]),.b1r1ramRD1(b1r15ramRD1[7]),.b1r1ramRD2(b1r15ramRD2[7]));
    B1R1RAM b1r1rm8(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[8]),.b1r1ramRD1(b1r15ramRD1[8]),.b1r1ramRD2(b1r15ramRD2[8]));
    B1R1RAM b1r1rm9(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[9]),.b1r1ramRD1(b1r15ramRD1[9]),.b1r1ramRD2(b1r15ramRD2[9]));
    B1R1RAM b1r1rm10(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[10]),.b1r1ramRD1(b1r15ramRD1[10]),.b1r1ramRD2(b1r15ramRD2[10]));
    B1R1RAM b1r1rm11(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[11]),.b1r1ramRD1(b1r15ramRD1[11]),.b1r1ramRD2(b1r15ramRD2[11]));
    B1R1RAM b1r1rm12(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[12]),.b1r1ramRD1(b1r15ramRD1[12]),.b1r1ramRD2(b1r15ramRD2[12]));
    B1R1RAM b1r1rm13(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[13]),.b1r1ramRD1(b1r15ramRD1[13]),.b1r1ramRD2(b1r15ramRD2[13]));
    B1R1RAM b1r1rm14(.b1r1ramCLK(b1r15ramCLK),.b1r1ramRS1(b1r15ramRS1),.b1r1ramRS2(b1r15ramRS2),.b1r1ramWS(b1r15ramWS),.b1r1ramWD(b1r15ramWD[14]),.b1r1ramRD1(b1r15ramRD1[14]),.b1r1ramRD2(b1r15ramRD2[14]));

endmodule

module B4TO16DECODER(
    input wire [3:0] b4to16decoderS,
    
    output wire [15:0] b4to16decoderO
);
    reg [15:0] dout;
    always @(b4to16decoderS) begin
        if(b4to16decoderS == 4'b0000)       dout = 16'b0000000000000001;
        else if(b4to16decoderS === 4'b0001) dout = 16'b0000000000000010;
        else if(b4to16decoderS === 4'b0010) dout = 16'b0000000000000100;
        else if(b4to16decoderS === 4'b0011) dout = 16'b0000000000001000;
        else if(b4to16decoderS === 4'b0100) dout = 16'b0000000000010000;
        else if(b4to16decoderS === 4'b0101) dout = 16'b0000000000100000;
        else if(b4to16decoderS === 4'b0110) dout = 16'b0000000001000000;
        else if(b4to16decoderS === 4'b0111) dout = 16'b0000000010000000;
        else if(b4to16decoderS === 4'b1000) dout = 16'b0000000100000000;
        else if(b4to16decoderS === 4'b1001) dout = 16'b0000001000000000;
        else if(b4to16decoderS === 4'b1010) dout = 16'b0000010000000000;
        else if(b4to16decoderS === 4'b1011) dout = 16'b0000100000000000;
        else if(b4to16decoderS === 4'b1100) dout = 16'b0001000000000000;
        else if(b4to16decoderS === 4'b1101) dout = 16'b0010000000000000;
        else if(b4to16decoderS === 4'b1110) dout = 16'b0100000000000000;
        else if(b4to16decoderS === 4'b1111) dout = 16'b1000000000000000;
        else                                dout = 16'b0000000000000000;
    end
    
    assign b4to16decoderO = dout;
endmodule

module B10R15RAM(
    input wire [3:0] b10r15ramRA1,
    input wire [3:0] b10r15ramRA2,
    input wire [3:0] b10r15ramWA,
    input wire [14:0] b10r15ramWD,
    input wire b10r15ramWE,
    input wire b10r15ramCLK,

    output wire [14:0] b10r15ramRD1,
    output wire [14:0] b10r15ramRD2
);
    reg [14:0] ramen;
    reg [14:0] RO1;
    reg [14:0] RO2;

    wire [14:0] O1 [9:0];
    wire [14:0] O2 [9:0];
    wire [14:0] ramsl1w;
    wire [14:0] ramsl2w;
    wire [14:0] ramenw;

    B4TO16DECODER ramsl1tor(.b4to16decoderS(b10r15ramRA1),.b4to16decoderO(ramsl1w));
    B4TO16DECODER ramsl2tor(.b4to16decoderS(b10r15ramRA2),.b4to16decoderO(ramsl2w));

    B4TO16DECODER ramenableor(.b4to16decoderS(b10r15ramWA),.b4to16decoderO(ramenw));
    
    always @(b10r15ramWE or ramenw) begin
        ramen = (b10r15ramWE)?ramenw:0;
    end

    B1R15RAM b1r1ram0(.b1r15ramRS1(ramsl1w[0]),.b1r15ramRS2(ramsl2w[0]),.b1r15ramWS(ramen[0]),.b1r15ramWD(b10r15ramWD),.b1r15ramCLK(b10r15ramCLK),.b1r15ramRD1(O1[0]),.b1r15ramRD2(O2[0]));
    B1R15RAM b1r1ram1(.b1r15ramRS1(ramsl1w[1]),.b1r15ramRS2(ramsl2w[1]),.b1r15ramWS(ramen[1]),.b1r15ramWD(b10r15ramWD),.b1r15ramCLK(b10r15ramCLK),.b1r15ramRD1(O1[1]),.b1r15ramRD2(O2[1]));
    B1R15RAM b1r1ram2(.b1r15ramRS1(ramsl1w[2]),.b1r15ramRS2(ramsl2w[2]),.b1r15ramWS(ramen[2]),.b1r15ramWD(b10r15ramWD),.b1r15ramCLK(b10r15ramCLK),.b1r15ramRD1(O1[2]),.b1r15ramRD2(O2[2]));
    B1R15RAM b1r1ram3(.b1r15ramRS1(ramsl1w[3]),.b1r15ramRS2(ramsl2w[3]),.b1r15ramWS(ramen[3]),.b1r15ramWD(b10r15ramWD),.b1r15ramCLK(b10r15ramCLK),.b1r15ramRD1(O1[3]),.b1r15ramRD2(O2[3]));
    B1R15RAM b1r1ram4(.b1r15ramRS1(ramsl1w[4]),.b1r15ramRS2(ramsl2w[4]),.b1r15ramWS(ramen[4]),.b1r15ramWD(b10r15ramWD),.b1r15ramCLK(b10r15ramCLK),.b1r15ramRD1(O1[4]),.b1r15ramRD2(O2[4]));
    B1R15RAM b1r1ram5(.b1r15ramRS1(ramsl1w[5]),.b1r15ramRS2(ramsl2w[5]),.b1r15ramWS(ramen[5]),.b1r15ramWD(b10r15ramWD),.b1r15ramCLK(b10r15ramCLK),.b1r15ramRD1(O1[5]),.b1r15ramRD2(O2[5]));
    B1R15RAM b1r1ram6(.b1r15ramRS1(ramsl1w[6]),.b1r15ramRS2(ramsl2w[6]),.b1r15ramWS(ramen[6]),.b1r15ramWD(b10r15ramWD),.b1r15ramCLK(b10r15ramCLK),.b1r15ramRD1(O1[6]),.b1r15ramRD2(O2[6]));
    B1R15RAM b1r1ram7(.b1r15ramRS1(ramsl1w[7]),.b1r15ramRS2(ramsl2w[7]),.b1r15ramWS(ramen[7]),.b1r15ramWD(b10r15ramWD),.b1r15ramCLK(b10r15ramCLK),.b1r15ramRD1(O1[7]),.b1r15ramRD2(O2[7]));
    B1R15RAM b1r1ram8(.b1r15ramRS1(ramsl1w[8]),.b1r15ramRS2(ramsl2w[8]),.b1r15ramWS(ramen[8]),.b1r15ramWD(b10r15ramWD),.b1r15ramCLK(b10r15ramCLK),.b1r15ramRD1(O1[8]),.b1r15ramRD2(O2[8]));
    B1R15RAM b1r1ram9(.b1r15ramRS1(ramsl1w[9]),.b1r15ramRS2(ramsl2w[9]),.b1r15ramWS(ramen[9]),.b1r15ramWD(b10r15ramWD),.b1r15ramCLK(b10r15ramCLK),.b1r15ramRD1(O1[9]),.b1r15ramRD2(O2[9]));

    always @(ramsl1w or O1[0] or O1[1] or O1[2] or O1[3] or O1[4] or O1[5] or O1[6] or O1[7] or O1[8] or O1[9]) begin
        if(ramsl1w[0] == 1'b1)      RO1 = O1[0];
        else if(ramsl1w[1] == 1'b1) RO1 = O1[1];
        else if(ramsl1w[2] == 1'b1) RO1 = O1[2];
        else if(ramsl1w[3] == 1'b1) RO1 = O1[3];
        else if(ramsl1w[4] == 1'b1) RO1 = O1[4];
        else if(ramsl1w[5] == 1'b1) RO1 = O1[5];
        else if(ramsl1w[6] == 1'b1) RO1 = O1[6];
        else if(ramsl1w[7] == 1'b1) RO1 = O1[7];
        else if(ramsl1w[8] == 1'b1) RO1 = O1[8];
        else if(ramsl1w[9] == 1'b1) RO1 = O1[9];
        else                        RO1 = 15'bzzzzzzzzzzzzzzz;
    end
    always @(ramsl2w or O2[0] or O2[1] or O2[2] or O2[3] or O2[4] or O2[5] or O2[6] or O2[7] or O2[8] or O2[9]) begin
        if(ramsl2w[0] == 1'b1)      RO2 = O2[0];
        else if(ramsl2w[1] == 1'b1) RO2 = O2[1];
        else if(ramsl2w[2] == 1'b1) RO2 = O2[2];
        else if(ramsl2w[3] == 1'b1) RO2 = O2[3];
        else if(ramsl2w[4] == 1'b1) RO2 = O2[4];
        else if(ramsl2w[5] == 1'b1) RO2 = O2[5];
        else if(ramsl2w[6] == 1'b1) RO2 = O2[6];
        else if(ramsl2w[7] == 1'b1) RO2 = O2[7];
        else if(ramsl2w[8] == 1'b1) RO2 = O2[8];
        else if(ramsl2w[9] == 1'b1) RO2 = O2[9];
        else                        RO2 = 15'bzzzzzzzzzzzzzzz;
    end

    assign b10r15ramRD1 = RO1;
    assign b10r15ramRD2 = RO2;
endmodule