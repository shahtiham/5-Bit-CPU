// `include "REGISTER.v"
`include "RAM.v"
`include "ALU.v"

module PCADDER(
    input wire [3:0] pcaI,

    output wire [3:0] pcaO
);
    wire [3:0] pcaddcout;
    reg cnst0 = 0;
    reg cnst1 = 1;

    FA fa0(.faA(pcaI[0]),.faB(cnst1),.faCin(cnst0),.faCout(pcaddcout[0]),.faS(pcaO[0]));
    FA fa1(.faA(pcaI[1]),.faB(cnst0),.faCin(pcaddcout[0]),.faCout(pcaddcout[1]),.faS(pcaO[1]));
    FA fa2(.faA(pcaI[2]),.faB(cnst0),.faCin(pcaddcout[1]),.faCout(pcaddcout[2]),.faS(pcaO[2]));
    FA fa3(.faA(pcaI[3]),.faB(cnst0),.faCin(pcaddcout[2]),.faCout(pcaddcout[3]),.faS(pcaO[3]));

endmodule

module PC(
    input wire [3:0] pcI,
    input wire CPUCLK,

    output wire [3:0] pcO
);
    DFLIPFLOP pc0(.dflipflopC(CPUCLK),.dflipflopD(pcI[0]),.dflipflopQ(pcO[0]));
    DFLIPFLOP pc1(.dflipflopC(CPUCLK),.dflipflopD(pcI[1]),.dflipflopQ(pcO[1]));
    DFLIPFLOP pc2(.dflipflopC(CPUCLK),.dflipflopD(pcI[2]),.dflipflopQ(pcO[2]));
    DFLIPFLOP pc3(.dflipflopC(CPUCLK),.dflipflopD(pcI[3]),.dflipflopQ(pcO[3]));

endmodule

module B4T2TO1MUX(
    input wire [3:0] b4t2to1mux0,
    input wire [3:0] b4t2to1mux1,
    input wire b4t2to1muxSEL,

    output wire [3:0] b4t2to1muxO
);
    reg [3:0] o;
    always @(*) begin
        if     (b4t2to1muxSEL == 1'b0)  o = b4t2to1mux0;
        else if(b4t2to1muxSEL == 1'b1)  o = b4t2to1mux1;
        else                            o = 4'b0000;
    end
    assign b4t2to1muxO = o;

endmodule

module B5T2TO1MUX(
    input wire [4:0] b5t2to1mux0,
    input wire [4:0] b5t2to1mux1,
    input wire b5t2to1muxSEL,

    output wire [4:0] b5t2to1muxO
);
    reg [4:0] o;
    always @(*) begin
        if     (b5t2to1muxSEL == 1'b0)  o = b5t2to1mux0;
        else if(b5t2to1muxSEL == 1'b1)  o = b5t2to1mux1;
        else                            o = 5'b00000;
    end
    assign b5t2to1muxO = o;

endmodule

module FLAGREG(
    input wire SFi,
    input wire ZFi,
    input wire CLK,

    output wire SF,
    output wire ZF
);
    DFLIPFLOP S(.dflipflopC(CLK),.dflipflopD(SFi),.dflipflopQ(SF));
    DFLIPFLOP Z(.dflipflopC(CLK),.dflipflopD(ZFi),.dflipflopQ(ZF));

endmodule

module CPU(
    input wire CLOCK,
    input wire PCEN,
    input wire WE,
    input wire [3:0] WA,
    input wire [14:0] WD,
    input wire [3:0] D2,
    output wire [14:0] CPURD1,
    output wire [14:0] CPURD2,
    output wire [3:0] jmpto,
    output wire [3:0] pcINN,
    output wire jmpsel,
    output wire [4:0] immv,
    output wire [4:0] regOt,
    output wire [3:0] rampos,
    output wire [2:0] re1,
    output wire [2:0] re2,
    output wire [4:0] R
);
    wire Jmp, JmpS0, JmpS1, JmpS2, JmpSEL, Sf, Zf, CSF, CZ, Cren0, Cren, T0, T1, O0, O1, clk;
    wire [1:0] ALUop, TOOP;
    wire [2:0] R1, R2;
    wire [3:0] JmpTo, pcin, pcIn, pctopcadder;
    wire [4:0] IMMV, CRA, CRB, CRBf, CPUr;
    wire [14:0] ramRD1, ramRD2;

    assign IMMV = {CPURD1[4],CPURD1[3],CPURD1[2],CPURD1[1],CPURD1[0]};
    assign JmpTo = {CPURD1[3],CPURD1[2],CPURD1[1],CPURD1[0]};
    assign R2 = {CPURD1[7],CPURD1[6],CPURD1[5]};
    assign R1 = {CPURD1[10],CPURD1[9],CPURD1[8]};
    assign ALUop = {CPURD1[12],CPURD1[11]};
    assign TOOP = {CPURD1[14],CPURD1[13]};
    assign T0 = CPURD1[13];
    assign T1 = CPURD1[14];
    assign O0 = CPURD1[11];
    assign O1 = CPURD1[12];
    

    B4T2TO1MUX mux(.b4t2to1mux0(pcin),.b4t2to1mux1(JmpTo),.b4t2to1muxSEL(JmpSEL),.b4t2to1muxO(pcIn));

    assign clk = CLOCK & PCEN;
    PC pc(.pcI(pcIn),.CPUCLK(clk),.pcO(pctopcadder));

    PCADDER pcadder(.pcaI(pctopcadder),.pcaO(pcin));

    RAM ram(.b10r15ramRA1(pctopcadder),.b10r15ramRA2(D2),.b10r15ramWA(WA),.b10r15ramWD(WD),.b10r15ramWE(WE),.b10r15ramCLK(CLOCK),.b10r15ramRD1(ramRD1),.b10r15ramRD2(ramRD2));

    B5T2TO1MUX mux1b(.b5t2to1mux0(CRB),.b5t2to1mux1(IMMV),.b5t2to1muxSEL(T0),.b5t2to1muxO(CRBf));

    assign Cren0 = ~ (O0 & O1);
    assign Cren = Cren0 & T1;
    REGISTER regi(.regRa(R1),.regRb(R2),.regWr(R1),.regCLK(clk),.regEN(Cren),.regWRD(CPUr),.regA(CRA),.regB(CRB),.regO(regOt));

    ALU alu(.A(CRA),.B(CRBf),.OP(ALUop),.SF(Sf),.ZF(Zf),.R(CPUr));

    FLAGREG freg(.SFi(Sf),.ZFi(Zf),.CLK(CPUCLK),.SF(CSF),.ZF(CZF));

    assign Jmp = ~ (T0 | T1);
    assign JmpS0 = Jmp & (~ O1);
    assign JmpS1 = CSF | CZF;
    assign JmpS2 = Jmp & JmpS1 & O1;
    assign JmpSEL = JmpS0 | JmpS2;

    assign CPURD1 = ramRD1;
    assign CPURD2 = ramRD2;
    assign jmpto = JmpTo;
    assign pcINN = pcIn;
    assign jmpsel = JmpSEL;
    assign immv = IMMV;
    assign rampos = pctopcadder;
    assign re1 = R1;
    assign re2 = R2;
    assign R = CPUr;

endmodule