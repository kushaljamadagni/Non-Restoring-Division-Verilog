module full_adder(input wire a, b, cin, output wire o, cout);
    xor3 xor3_inst0(a,b,cin,o);
    wire [0:2] t;
    and2 and2_inst0(a,b,t[0]);
    and2 and2_inst1(a,cin,t[1]);
    and2 and2_inst2(b,cin,t[2]);
    or3 or3_inst0(t[1],t[0],t[2], cout);
endmodule

module csa(input wire a, b, cin, ctrl, output wire o, cout);
    wire t;
    xor2 xor2_inst0(a, ctrl, j);
    full_adder full_adder_inst0(j,b,cin,o,cout);
endmodule

module csa_16bit(input wire [15:0] M, T, input wire D, ctrl, output wire Q, output wire [15:0] R);
    wire [14:0] temp;
    csa csa_inst0(M[0], D, ctrl, ctrl, R[0], temp[0]);
    csa csa_inst1(M[1], T[0], temp[0], ctrl, R[1], temp[1]);
    csa csa_inst2(M[2], T[1], temp[1], ctrl, R[2], temp[2]);
    csa csa_inst3(M[3], T[2], temp[2], ctrl, R[3], temp[3]);
    csa csa_inst4(M[4], T[3], temp[3], ctrl, R[4], temp[4]);
    csa csa_inst5(M[5], T[4], temp[4], ctrl, R[5], temp[5]);
    csa csa_inst6(M[6], T[5], temp[5], ctrl, R[6], temp[6]);
    csa csa_inst7(M[7], T[6], temp[6], ctrl, R[7], temp[7]);
    csa csa_inst8(M[8], T[7], temp[7], ctrl, R[8], temp[8]);
    csa csa_inst9(M[9], T[8], temp[8], ctrl, R[9], temp[9]);
    csa csa_inst10(M[10], T[9], temp[9], ctrl, R[10], temp[10]);
    csa csa_inst11(M[11], T[10], temp[10], ctrl, R[11], temp[11]);
    csa csa_inst12(M[12], T[11], temp[11], ctrl, R[12], temp[12]);
    csa csa_inst13(M[13], T[12], temp[12], ctrl, R[13], temp[13]);
    csa csa_inst14(M[14], T[13], temp[13], ctrl, R[14], temp[14]);
    csa csa_inst15(M[15], T[14], temp[14], ctrl, R[15], Q);
endmodule

module non_restoring_divider(input wire [15:0] Q, M, output wire [15:0] quo, r);
    wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
    //wire [15:0] quo;
    csa_16bit csa_16bit_inst0(M, 16'b0, Q[15], 1'b1, quo[15], r0);
    csa_16bit csa_16bit_inst1(M, r0, Q[14], quo[15], quo[14],r1);
    csa_16bit csa_16bit_inst2(M, r1, Q[13], quo[14], quo[13],r2);
    csa_16bit csa_16bit_inst3(M, r2, Q[12], quo[13], quo[12],r3);
    csa_16bit csa_16bit_inst4(M, r3, Q[11], quo[12], quo[11],r4);
    csa_16bit csa_16bit_inst5(M, r4, Q[10], quo[11], quo[10],r5);
    csa_16bit csa_16bit_inst6(M, r5, Q[9], quo[10], quo[9],r6);
    csa_16bit csa_16bit_inst7(M, r6, Q[8], quo[9], quo[8],r7);
    csa_16bit csa_16bit_inst8(M, r7, Q[7], quo[8], quo[7],r8);
    csa_16bit csa_16bit_inst9(M, r8, Q[6], quo[7], quo[6],r9);
    csa_16bit csa_16bit_inst10(M, r9, Q[5], quo[6], quo[5],r10);
    csa_16bit csa_16bit_inst11(M, r10, Q[4], quo[5], quo[4],r11);
    csa_16bit csa_16bit_inst12(M, r11, Q[3], quo[4], quo[3],r12);
    csa_16bit csa_16bit_inst13(M, r12, Q[2], quo[3], quo[2],r13);
    csa_16bit csa_16bit_inst14(M, r13, Q[1], quo[2], quo[1],r14);
    csa_16bit csa_16bit_inst15(M, r14, Q[0], quo[1], quo[0],r);
    //assign q = quo;
endmodule
module ripple_carry_adder_rem_correc(input [3:0] in0,output [3:0] out,output cout);
	wire c1, c2, c3;
    wire an0,an1,an2,an3;
    wire a,b,c,d;
     reg [15:0] Q, M;
    wire [15:0] quo, rem;
    reg [3:0] in0;
	reg [3:0] in1;
	wire [3:0] out;
	wire cout;
    and2 and_1(1,io[3],an0);
    and2 and_2(0,io[3],an1);
    and2 and_3(1,io[3],an2);
    and2 and_4(0,io[3],an3);

    full_adder fa0(in0[0], an0, 0, out[0],c1);
    full_adder fa1(in0[1], an1, c1, out[1], c2);
    full_adder fa2(in0[2], an2, c2, out[2], c3);
    full_adder fa3(in0[3], an3, c3, out[3], cout);

endmodule
module testbench;
    reg [15:0] Q, M;
    wire [15:0] quo, rem;
    non_restoring_divider inst1(Q,M,quo,rem);
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0,testbench); //0,1
    end
    ripple_carry_adder_rem_correc rca(.in0(in0), .in1(in1), .out(out), .cout(cout));
    initial begin
        $dumpfile("ripple-carry_adder_rem_correc.vcd");
        $dumpvars(0, testbench);
		$monitor($time, ": %b + %b = %b, %b", in0, in1, out, cout);
	end

    initial begin
    $monitor (Q,M,quo,rem);
    Q = 16'd90;
    M = 16'd33;
    #10
    Q = 16'd901;
    M = 16'd300;

    end
endmodule
