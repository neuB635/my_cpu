module mul (
  input wire clk,
  input wire resetn,
  input wire mul_signed, //signed is 1, unsigned is 0
  input wire [31:0] ina,
  input wire [31:0] inb,
  output wire signed [63:0] result

);
`define Signed 1'b1
`define UnSigned 1'b0


  reg [31:0] ex_ina;
  reg [31:0] ex_inb;
  reg reverse;

  reg [62 :0] temp0;
  reg [61 :0] temp1;
  reg [60 :0] temp2;
  reg [59 :0] temp3;
  reg [58 :0] temp4;
  reg [57 :0] temp5;
  reg [56 :0] temp6;
  reg [55 :0] temp7;
  reg [54 :0] temp8;
  reg [53 :0] temp9;
  reg [52 :0] temp10;
  reg [51 :0] temp11;
  reg [50 :0] temp12;
  reg [49 :0] temp13;
  reg [48 :0] temp14;
  reg [47 :0] temp15;
  reg [46 :0] temp16;
  reg [45 :0] temp17;
  reg [44 :0] temp18;
  reg [43 :0] temp19;
  reg [42 :0] temp20;
  reg [41 :0] temp21;
  reg [40 :0] temp22;
  reg [39 :0] temp23;
  reg [38 :0] temp24;
  reg [37 :0] temp25;
  reg [36 :0] temp26;
  reg [35 :0] temp27;
  reg [34 :0] temp28;
  reg [33 :0] temp29;
  reg [32 :0] temp30;
  reg [31 :0] temp31;

  wire [63:0] out1_0;
  wire [61:0] out1_1;
  wire [59:0] out1_2;
  wire [57:0] out1_3;
  wire [55:0] out1_4;
  wire [53:0] out1_5;
  wire [51:0] out1_6;
  wire [49:0] out1_7;
  wire [47:0] out1_8;
  wire [45:0] out1_9;
  wire [43:0] out1_10;
  wire [41:0] out1_11;
  wire [39:0] out1_12;
  wire [37:0] out1_13;
  wire [35:0] out1_14;
  wire [33:0] out1_15;

  wire [63:0] out2_0;
	wire [59:0] out2_1;
	wire [55:0] out2_2;
	wire [51:0] out2_3;
	wire [47:0] out2_4;
	wire [43:0] out2_5;
	wire [39:0] out2_6;
	wire [35:0] out2_7;

  wire [63:0] out3_0;
	wire [55:0] out3_1;
	wire [47:0] out3_2;
	wire [39:0] out3_3;

  wire [63:0] out4_0;
	wire [47:0] out4_1;
    
  // 32*1乘法器

  function [31:0] mut32_1;
  input [31:0] operand;
  input sel;

  begin
    mut32_1 = sel ? operand : 32'b0;
  end
  endfunction

  always @ (*) begin
    if (!resetn) begin
      temp0=63'b0;
      temp1=62'b0;
      temp2=61'b0;
      temp3=60'b0;
      temp4=59'b0;
      temp5=58'b0;
      temp6=57'b0;
      temp7=56'b0;
      temp8=55'b0;
      temp9=54'b0;
      temp10=53'b0;
      temp11=52'b0;
      temp12=51'b0;
      temp13=50'b0;
      temp14=49'b0;
      temp15=48'b0;
      temp16=47'b0;
      temp17=46'b0;
      temp18=45'b0;
      temp19=44'b0;
      temp20=43'b0;
      temp21=42'b0;
      temp22=41'b0;
      temp23=40'b0;
      temp24=39'b0;
      temp25=38'b0;
      temp26=37'b0;
      temp27=36'b0;
      temp28=35'b0;
      temp29=34'b0;
      temp30=33'b0;
      temp31=32'b0;
    end
    else begin
      if (mul_signed==`UnSigned) begin
        ex_ina=ina;
        ex_inb=inb;
        reverse=1'b0;
      end else begin
        ex_ina=ina;
        ex_inb=inb;
        if(ina[31]==1'b1) begin
          ex_ina=~(ina-1);
        end
        if (inb[31]==1'b1) begin
          ex_inb=~(inb-1);
        end
        reverse=ina[31]+inb[31];
      end
      temp31=mut32_1(ex_ina,ex_inb[0]);
      temp30=mut32_1(ex_ina,ex_inb[1])<<1;
      temp29=mut32_1(ex_ina,ex_inb[2])<<2;
      temp28=mut32_1(ex_ina,ex_inb[3])<<3;
      temp27=mut32_1(ex_ina,ex_inb[4])<<4;
      temp26=mut32_1(ex_ina,ex_inb[5])<<5;
      temp25=mut32_1(ex_ina,ex_inb[6])<<6;
      temp24=mut32_1(ex_ina,ex_inb[7])<<7;
      temp23=mut32_1(ex_ina,ex_inb[8])<<8;
      temp22=mut32_1(ex_ina,ex_inb[9])<<9;
      temp21=mut32_1(ex_ina,ex_inb[10])<<10;
      temp20=mut32_1(ex_ina,ex_inb[11])<<11;
      temp19=mut32_1(ex_ina,ex_inb[12])<<12;
      temp18=mut32_1(ex_ina,ex_inb[13])<<13;
      temp17=mut32_1(ex_ina,ex_inb[14])<<14;
      temp16=mut32_1(ex_ina,ex_inb[15])<<15;
      temp15=mut32_1(ex_ina,ex_inb[16])<<16;
      temp14=mut32_1(ex_ina,ex_inb[17])<<17;
      temp13=mut32_1(ex_ina,ex_inb[18])<<18;
      temp12=mut32_1(ex_ina,ex_inb[19])<<19;
      temp11=mut32_1(ex_ina,ex_inb[20])<<20;
      temp10=mut32_1(ex_ina,ex_inb[21])<<21;
      temp9=mut32_1(ex_ina,ex_inb[22])<<22;
      temp8=mut32_1(ex_ina,ex_inb[23])<<23;
      temp7=mut32_1(ex_ina,ex_inb[24])<<24;
      temp6=mut32_1(ex_ina,ex_inb[25])<<25;
      temp5=mut32_1(ex_ina,ex_inb[26])<<26;
      temp4=mut32_1(ex_ina,ex_inb[27])<<27;
      temp3=mut32_1(ex_ina,ex_inb[28])<<28;
      temp2=mut32_1(ex_ina,ex_inb[29])<<29;
      temp1=mut32_1(ex_ina,ex_inb[30])<<30;
      temp0=mut32_1(ex_ina,ex_inb[31])<<31;
    end
  end

  assign out1_0 = temp0+temp1;
	assign out1_1 = temp2+temp3;
	assign out1_2 = temp4+temp5;
	assign out1_3 = temp6+temp7;
	assign out1_4 = temp8+temp9;
	assign out1_5 = temp10+temp11;
	assign out1_6 = temp12+temp13;
	assign out1_7 = temp14+temp15;
	assign out1_8 = temp16+temp17;
	assign out1_9 = temp18+temp19;
	assign out1_10 = temp20+temp21;
	assign out1_11 = temp22+temp23;
	assign out1_12 = temp24+temp25;
	assign out1_13 = temp26+temp27;
	assign out1_14 = temp28+temp29;
	assign out1_15 = temp30+temp31;

  assign out2_0 = out1_0+out1_1;
	assign out2_1 = out1_2+out1_3;
	assign out2_2 = out1_4+out1_5;
	assign out2_3 = out1_6+out1_7;
	assign out2_4 = out1_8+out1_9;
	assign out2_5 = out1_10+out1_11;
	assign out2_6 = out1_12+out1_13;
	assign out2_7 = out1_14+out1_15;

  assign out3_0 = out2_0+out2_1;
	assign out3_1 = out2_2+out2_3;
	assign out3_2 = out2_4+out2_5;
	assign out3_3 = out2_6+out2_7;

  assign out4_0 = out3_0+out3_1;
	assign out4_1 = out3_2+out3_3;

  assign result=reverse?~(out4_0+out4_1)+1'b1:out4_0+out4_1;


//原来代码开始
/*
  reg one_mul_signed;
  reg [31:0] one_ina;
  reg [31:0] one_inb;
  reg signed [64:0] mul_temp [16:0];
  wire signed [32:0] ext_ina;
  wire signed [32:0] ext_inb;
  wire [1:0] code [16:0];
  wire [64:0] out;
  reg [33:0] kkk [15:0];
  reg [32:0] kkk1 [15:0];
  
//  always @ (posedge clk, posedge resetn) begin
//    if (!resetn) begin
//      one_mul_signed <= 1'b0;
//      one_ina <= 32'b0;
//      one_inb <= 32'b0;
//    end
//    else begin
//      one_mul_signed <= mul_signed;
//      one_ina <= ina;
//      one_inb <= inb;
//    end
//  end
//  reset
  
  //Extended implementation of signed and unsigned multiplication
  assign ext_ina = {mul_signed & ina[31], ina};
  assign ext_inb = {mul_signed & inb[31], inb};
    
  //decoder
  assign code[ 0][0] = ext_ina[ 1] & ext_ina[ 0];
  assign code[ 1][0] = (ext_ina[ 1] & ext_ina[ 2] & ~ext_ina[ 3]) + (ext_ina[ 1] & ~ext_ina[ 2] & ext_ina[ 3]) + (~ext_ina[ 1] & ext_ina[ 2] & ext_ina[ 3]);
  assign code[ 2][0] = (ext_ina[ 3] & ext_ina[ 4] & ~ext_ina[ 5]) + (ext_ina[ 3] & ~ext_ina[ 4] & ext_ina[ 5]) + (~ext_ina[ 3] & ext_ina[ 4] & ext_ina[ 5]);
  assign code[ 3][0] = (ext_ina[ 5] & ext_ina[ 6] & ~ext_ina[ 7]) + (ext_ina[ 5] & ~ext_ina[ 6] & ext_ina[ 7]) + (~ext_ina[ 5] & ext_ina[ 6] & ext_ina[ 7]);
  assign code[ 4][0] = (ext_ina[ 7] & ext_ina[ 8] & ~ext_ina[ 9]) + (ext_ina[ 7] & ~ext_ina[ 8] & ext_ina[ 9]) + (~ext_ina[ 7] & ext_ina[ 8] & ext_ina[ 9]);
  assign code[ 5][0] = (ext_ina[ 9] & ext_ina[10] & ~ext_ina[11]) + (ext_ina[ 9] & ~ext_ina[10] & ext_ina[11]) + (~ext_ina[ 9] & ext_ina[10] & ext_ina[11]);
  assign code[ 6][0] = (ext_ina[11] & ext_ina[12] & ~ext_ina[13]) + (ext_ina[11] & ~ext_ina[12] & ext_ina[13]) + (~ext_ina[11] & ext_ina[12] & ext_ina[13]);
  assign code[ 7][0] = (ext_ina[13] & ext_ina[14] & ~ext_ina[15]) + (ext_ina[13] & ~ext_ina[14] & ext_ina[15]) + (~ext_ina[13] & ext_ina[14] & ext_ina[15]);
  assign code[ 8][0] = (ext_ina[15] & ext_ina[16] & ~ext_ina[17]) + (ext_ina[15] & ~ext_ina[16] & ext_ina[17]) + (~ext_ina[15] & ext_ina[16] & ext_ina[17]);
  assign code[ 9][0] = (ext_ina[17] & ext_ina[18] & ~ext_ina[19]) + (ext_ina[17] & ~ext_ina[18] & ext_ina[19]) + (~ext_ina[17] & ext_ina[18] & ext_ina[19]);
  assign code[10][0] = (ext_ina[19] & ext_ina[20] & ~ext_ina[21]) + (ext_ina[19] & ~ext_ina[20] & ext_ina[21]) + (~ext_ina[19] & ext_ina[20] & ext_ina[21]);
  assign code[11][0] = (ext_ina[21] & ext_ina[22] & ~ext_ina[23]) + (ext_ina[21] & ~ext_ina[22] & ext_ina[23]) + (~ext_ina[21] & ext_ina[22] & ext_ina[23]);
  assign code[12][0] = (ext_ina[23] & ext_ina[24] & ~ext_ina[25]) + (ext_ina[23] & ~ext_ina[24] & ext_ina[25]) + (~ext_ina[23] & ext_ina[24] & ext_ina[25]);
  assign code[13][0] = (ext_ina[25] & ext_ina[26] & ~ext_ina[27]) + (ext_ina[25] & ~ext_ina[26] & ext_ina[27]) + (~ext_ina[25] & ext_ina[26] & ext_ina[27]);
  assign code[14][0] = (ext_ina[27] & ext_ina[28] & ~ext_ina[29]) + (ext_ina[27] & ~ext_ina[28] & ext_ina[29]) + (~ext_ina[27] & ext_ina[28] & ext_ina[29]);
  assign code[15][0] = (ext_ina[29] & ext_ina[30] & ~ext_ina[31]) + (ext_ina[29] & ~ext_ina[30] & ext_ina[31]) + (~ext_ina[29] & ext_ina[30] & ext_ina[31]);
  assign code[16][0] = 1'b0;
      
  assign code[ 0][1] = ext_ina[ 1];
  assign code[ 1][1] = (~ext_ina[ 1] & ext_ina[ 2] & ext_ina[ 3]) + (~ext_ina[ 2] & ext_ina[ 3]);
  assign code[ 2][1] = (~ext_ina[ 3] & ext_ina[ 4] & ext_ina[ 5]) + (~ext_ina[ 4] & ext_ina[ 5]);
  assign code[ 3][1] = (~ext_ina[ 5] & ext_ina[ 6] & ext_ina[ 7]) + (~ext_ina[ 6] & ext_ina[ 7]);
  assign code[ 4][1] = (~ext_ina[ 7] & ext_ina[ 8] & ext_ina[ 9]) + (~ext_ina[ 8] & ext_ina[ 9]);
  assign code[ 5][1] = (~ext_ina[ 9] & ext_ina[10] & ext_ina[11]) + (~ext_ina[10] & ext_ina[11]);
  assign code[ 6][1] = (~ext_ina[11] & ext_ina[12] & ext_ina[13]) + (~ext_ina[12] & ext_ina[13]);
  assign code[ 7][1] = (~ext_ina[13] & ext_ina[14] & ext_ina[15]) + (~ext_ina[14] & ext_ina[15]);
  assign code[ 8][1] = (~ext_ina[15] & ext_ina[16] & ext_ina[17]) + (~ext_ina[16] & ext_ina[17]);
  assign code[ 9][1] = (~ext_ina[17] & ext_ina[18] & ext_ina[19]) + (~ext_ina[18] & ext_ina[19]);
  assign code[10][1] = (~ext_ina[19] & ext_ina[20] & ext_ina[21]) + (~ext_ina[20] & ext_ina[21]);
  assign code[11][1] = (~ext_ina[21] & ext_ina[22] & ext_ina[23]) + (~ext_ina[22] & ext_ina[23]);
  assign code[12][1] = (~ext_ina[23] & ext_ina[24] & ext_ina[25]) + (~ext_ina[24] & ext_ina[25]);
  assign code[13][1] = (~ext_ina[25] & ext_ina[26] & ext_ina[27]) + (~ext_ina[26] & ext_ina[27]);
  assign code[14][1] = (~ext_ina[27] & ext_ina[28] & ext_ina[29]) + (~ext_ina[28] & ext_ina[29]);
  assign code[15][1] = (~ext_ina[29] & ext_ina[30] & ext_ina[31]) + (~ext_ina[30] & ext_ina[31]);
  assign code[16][1] = 1'b0;
      
  always @ (*) begin
    //2-bit booth encoding
    case(code[ 0])
      2'b00: begin
        mul_temp[ 0] = (~ext_ina[ 0] & ~ext_ina[ 1]) ? 65'b0 : {{32{ext_inb[32]}}, ext_inb};
      end
      2'b01: begin
        mul_temp[ 0] = {{31{ext_inb[32]}}, ext_inb << 1};
      end
      2'b10: begin
        kkk[ 0] = (~ext_inb + 1) << 1;
        mul_temp[ 0] = {{31{kkk[ 0][33]}}, kkk[ 0]};
      end
      2'b11: begin
        kkk1[ 0] = ~ext_inb + 1;
        mul_temp[ 0] = {{32{kkk1[ 0][32]}}, kkk1[ 0]};
      end
      default: begin
        mul_temp[ 0] = 65'b0;
      end
    endcase
    case(code[ 1])
      2'b00:begin
        mul_temp[ 1] = (ext_ina[ 1] & ext_ina[ 2] & ext_ina[ 3] || ~ext_ina[ 1] & ~ext_ina[ 2] & ~ext_ina[ 3]) ? 65'b0 : ({{30{ext_inb[32]}}, ext_inb, 2'b0});
      end
      2'b01:begin
        mul_temp[ 1] = {{29{ext_inb[32]}}, ext_inb << 1, 2'b0};
      end
      2'b10:begin
        kkk[ 1] = (~ext_inb + 1) << 1;
        mul_temp[ 1] = {{29{kkk[ 1][33]}}, kkk[ 1], 2'b0};
      end
      2'b11:begin
        kkk1[ 1] = ~ext_inb + 1;
        mul_temp[ 1] = {{30{kkk1[ 1][32]}}, kkk1[ 1], 2'b0};
      end
      default:begin
        mul_temp[ 1] = 65'b0;
      end
    endcase
    case(code[ 2])
      2'b00:begin
        mul_temp[ 2] = (ext_ina[ 3] & ext_ina[ 4] & ext_ina[ 5] || ~ext_ina[ 3] & ~ext_ina[ 4] & ~ext_ina[ 5]) ? 65'b0 : ({{28{ext_inb[32]}}, ext_inb, 4'b0});
      end
      2'b01:begin
        mul_temp[ 2] = {{27{ext_inb[32]}}, ext_inb << 1, 4'b0};
      end
      2'b10:begin
        kkk[ 2] = (~ext_inb + 1) << 1;
        mul_temp[ 2] = {{27{kkk[ 2][33]}}, kkk[ 2], 4'b0};
      end
      2'b11:begin
        kkk1[ 2] = ~ext_inb + 1;
        mul_temp[ 2] = {{28{kkk1[ 2][32]}}, kkk1[ 2], 4'b0};
      end
      default:begin
        mul_temp[ 2] = 65'b0;
      end
    endcase
    case(code[ 3])
      2'b00:begin
        mul_temp[ 3] = (ext_ina[ 5] & ext_ina[ 6] & ext_ina[ 7] || ~ext_ina[ 5] & ~ext_ina[ 6] & ~ext_ina[ 7]) ? 65'b0 : ({{26{ext_inb[32]}}, ext_inb, 6'b0});
      end
      2'b01:begin
        mul_temp[ 3] = {{25{ext_inb[32]}}, ext_inb << 1, 6'b0};
      end
      2'b10:begin
        kkk[ 3] = (~ext_inb + 1) << 1;
        mul_temp[ 3] = {{25{kkk[ 3][33]}}, kkk[ 3], 6'b0};
      end
      2'b11:begin
        kkk1[ 3] = ~ext_inb + 1;
        mul_temp[ 3] = {{26{kkk1[ 3][32]}}, kkk1[ 3], 6'b0};
      end
      default:begin
        mul_temp[ 3] = 65'b0;
      end
    endcase
    case(code[ 4])
      2'b00:begin
        mul_temp[ 4] = (ext_ina[ 7] & ext_ina[ 8] & ext_ina[ 9] || ~ext_ina[ 7] & ~ext_ina[ 8] & ~ext_ina[ 9]) ? 65'b0 : ({{24{ext_inb[32]}}, ext_inb, 8'b0});
      end
      2'b01:begin
        mul_temp[ 4] = {{23{ext_inb[32]}}, ext_inb << 1, 8'b0};
      end
      2'b10:begin
        kkk[ 4] = (~ext_inb + 1) << 1;
        mul_temp[ 4] = {{23{kkk[ 4][33]}}, kkk[ 4], 8'b0};
      end
      2'b11:begin
        kkk1[ 4] = ~ext_inb + 1;
        mul_temp[ 4] = {{24{kkk1[ 4][32]}}, kkk1[ 4], 8'b0};
      end
      default:begin
        mul_temp[ 4] = 65'b0;
      end
    endcase
    case(code[ 5])
      2'b00:begin
        mul_temp[ 5] = (ext_ina[ 9] & ext_ina[10] & ext_ina[11] || ~ext_ina[ 9] & ~ext_ina[10] & ~ext_ina[11]) ? 65'b0 : ({{22{ext_inb[32]}}, ext_inb, 10'b0});
      end
      2'b01:begin
        mul_temp[ 5] = {{21{ext_inb[32]}}, ext_inb << 1, 10'b0};
      end
      2'b10:begin
        kkk[ 5] = (~ext_inb + 1) << 1;
        mul_temp[ 5] = {{21{kkk[ 5][33]}}, kkk[ 5], 10'b0};
      end
      2'b11:begin
        kkk1[ 5] = ~ext_inb + 1;
        mul_temp[ 5] = {{22{kkk1[ 5][32]}}, kkk1[ 5], 10'b0};
      end
      default:begin
        mul_temp[ 5] = 65'b0;
      end
    endcase
    case(code[ 6])
      2'b00:begin
        mul_temp[ 6] = (ext_ina[11] & ext_ina[12] & ext_ina[13] || ~ext_ina[11] & ~ext_ina[12] & ~ext_ina[13]) ? 65'b0 : ({{20{ext_inb[32]}}, ext_inb, 12'b0});
      end
      2'b01:begin
        mul_temp[ 6] = {{19{ext_inb[32]}}, ext_inb << 1, 12'b0};
      end
      2'b10:begin
        kkk[ 6] = (~ext_inb + 1) << 1;
        mul_temp[ 6] = {{19{kkk[ 6][33]}}, kkk[ 6], 12'b0};
      end
      2'b11:begin
        kkk1[ 6] = ~ext_inb + 1;
        mul_temp[ 6] = {{20{kkk1[ 6][32]}}, kkk1[ 6], 12'b0};
      end
      default:begin
        mul_temp[ 6] = 65'b0;
      end
    endcase
    case(code[ 7])
      2'b00:begin
        mul_temp[ 7] = (ext_ina[13] & ext_ina[14] & ext_ina[15] || ~ext_ina[13] & ~ext_ina[14] & ~ext_ina[15]) ? 65'b0 : ({{18{ext_inb[32]}}, ext_inb, 14'b0});
      end
      2'b01:begin
        mul_temp[ 7] = {{17{ext_inb[32]}}, ext_inb << 1, 14'b0};
      end
      2'b10:begin
        kkk[ 7] = (~ext_inb + 1) << 1;
        mul_temp[ 7] = {{17{kkk[ 7][33]}}, kkk[ 7], 14'b0};
      end
      2'b11:begin
        kkk1[ 7] = ~ext_inb + 1;
        mul_temp[ 7] = {{18{kkk1[ 7][32]}}, kkk1[ 7], 14'b0};
      end
      default:begin
        mul_temp[ 7] = 65'b0;
      end
    endcase
    case(code[ 8])
      2'b00:begin
        mul_temp[ 8] = (ext_ina[15] & ext_ina[16] & ext_ina[17] || ~ext_ina[15] & ~ext_ina[16] & ~ext_ina[17]) ? 65'b0 : ({{16{ext_inb[32]}}, ext_inb, 16'b0});
      end
      2'b01:begin
        mul_temp[ 8] = {{15{ext_inb[32]}}, ext_inb << 1, 16'b0};
      end
      2'b10:begin
        kkk[ 8] = (~ext_inb + 1) << 1;
        mul_temp[ 8] = {{15{kkk[ 8][33]}}, kkk[ 8], 16'b0};
      end
      2'b11:begin
        kkk1[ 8] = ~ext_inb + 1;
        mul_temp[ 8] = {{16{kkk1[ 8][32]}}, kkk1[ 8], 16'b0};
      end
      default:begin
        mul_temp[ 8] = 65'b0;
      end
    endcase
    case(code[ 9])
      2'b00:begin
        mul_temp[ 9] = (ext_ina[17] & ext_ina[18] & ext_ina[19] || ~ext_ina[17] & ~ext_ina[18] & ~ext_ina[19]) ? 65'b0 : ({{14{ext_inb[32]}}, ext_inb, 18'b0});
      end
      2'b01:begin
        mul_temp[ 9] = {{13{ext_inb[32]}}, ext_inb << 1, 18'b0};
      end
      2'b10:begin
        kkk[ 9] = (~ext_inb + 1) << 1;
        mul_temp[ 9] = {{13{kkk[ 9][33]}}, kkk[ 9], 18'b0};
      end
      2'b11:begin
        kkk1[ 9] = ~ext_inb + 1;
        mul_temp[ 9] = {{14{kkk1[ 9][32]}}, kkk1[ 9], 18'b0};
      end
      default:begin
        mul_temp[ 9] = 65'b0;
      end
    endcase
    case(code[10])
      2'b00:begin
        mul_temp[10] = (ext_ina[19] & ext_ina[20] & ext_ina[21] || ~ext_ina[19] & ~ext_ina[20] & ~ext_ina[21]) ? 65'b0 : ({{12{ext_inb[32]}}, ext_inb, 20'b0});
      end
      2'b01:begin
        mul_temp[10] = {{11{ext_inb[32]}}, ext_inb << 1, 20'b0};
      end
      2'b10:begin
        kkk[10] = (~ext_inb + 1) << 1;
        mul_temp[10] = {{11{kkk[10][33]}}, kkk[10], 20'b0};
      end
      2'b11:begin
        kkk1[10] = ~ext_inb + 1;
        mul_temp[10] = {{12{kkk1[10][32]}}, kkk1[10], 20'b0};
      end
      default:begin
        mul_temp[10] = 65'b0;
      end
    endcase
    case(code[11])
      2'b00:begin
        mul_temp[11] = (ext_ina[21] & ext_ina[22] & ext_ina[23] || ~ext_ina[21] & ~ext_ina[22] & ~ext_ina[23]) ? 65'b0 : ({{10{ext_inb[32]}}, ext_inb, 22'b0});
      end
      2'b01:begin
        mul_temp[11] = {{9{ext_inb[32]}}, ext_inb << 1, 22'b0};
      end
      2'b10:begin
        kkk[11] = (~ext_inb + 1) << 1;
        mul_temp[11] = {{9{kkk[11][33]}}, kkk[11], 22'b0};
      end
      2'b11:begin
        kkk1[11] = ~ext_inb + 1;
        mul_temp[11] = {{10{kkk1[11][32]}}, kkk1[11], 22'b0};
      end
      default:begin
        mul_temp[11] = 65'b0;
      end
    endcase
    case(code[12])
      2'b00:begin
        mul_temp[12] = (ext_ina[23] & ext_ina[24] & ext_ina[25] || ~ext_ina[23] & ~ext_ina[24] & ~ext_ina[25]) ? 65'b0 : ({{8{ext_inb[32]}}, ext_inb, 24'b0});
      end
      2'b01:begin
        mul_temp[12] = {{7{ext_inb[32]}}, ext_inb << 1, 24'b0};
      end
      2'b10:begin
        kkk[12] = (~ext_inb + 1) << 1;
        mul_temp[12] = {{7{kkk[12][33]}}, kkk[12], 24'b0};
      end
      2'b11:begin
        kkk1[12] = ~ext_inb + 1;
        mul_temp[12] = {{8{kkk1[12][32]}}, kkk1[12], 24'b0};
      end
      default:begin
        mul_temp[12] = 65'b0;
      end
    endcase
    case(code[13])
      2'b00:begin
        mul_temp[13] = (ext_ina[25] & ext_ina[26] & ext_ina[27] || ~ext_ina[25] & ~ext_ina[26] & ~ext_ina[27]) ? 65'b0 : ({{6{ext_inb[32]}}, ext_inb, 26'b0});
      end
      2'b01:begin
        mul_temp[13] = {{5{ext_inb[32]}}, ext_inb << 1, 26'b0};
      end
      2'b10:begin
        kkk[13] = (~ext_inb + 1) << 1;
        mul_temp[13] = {{5{kkk[13][33]}}, kkk[13], 26'b0};
      end
      2'b11:begin
        kkk1[13] = ~ext_inb + 1;
        mul_temp[13] = {{6{kkk1[13][32]}}, kkk1[13], 26'b0};
      end
      default:begin
        mul_temp[13] = 65'b0;
      end
    endcase
    case(code[14])
      2'b00:begin
        mul_temp[14] = (ext_ina[27] & ext_ina[28] & ext_ina[29] || ~ext_ina[27] & ~ext_ina[28] & ~ext_ina[29]) ? 65'b0 : ({{4{ext_inb[32]}}, ext_inb, 28'b0});
      end
      2'b01:begin
        mul_temp[14] = {{3{ext_inb[32]}}, ext_inb << 1, 28'b0};
      end
      2'b10:begin
        kkk[14] = (~ext_inb + 1) << 1;
        mul_temp[14] = {{3{kkk[14][33]}}, kkk[14], 28'b0};
      end
      2'b11:begin
        kkk1[14] = ~ext_inb + 1;
        mul_temp[14] = {{4{kkk1[14][32]}}, kkk1[14], 28'b0};
      end
      default:begin
        mul_temp[14] = 65'b0;
      end
    endcase
    case(code[15])
      2'b00:begin
        mul_temp[15] = (ext_ina[29] & ext_ina[30] & ext_ina[31] || ~ext_ina[29] & ~ext_ina[30] & ~ext_ina[31]) ? 65'b0 : ({{2{ext_inb[32]}}, ext_inb, 30'b0});
      end
      2'b01:begin
        mul_temp[15] = {{1{ext_inb[32]}}, ext_inb << 1, 30'b0};
      end
      2'b10:begin
        kkk[15] = (~ext_inb + 1) << 1;
        mul_temp[15] = {{1{kkk[15][33]}}, kkk[15], 30'b0};
      end
      2'b11:begin
        kkk1[15] = ~ext_inb + 1;
        mul_temp[15] = {{2{kkk1[15][32]}}, kkk1[15], 30'b0};
      end
      default:begin
        mul_temp[15] = 65'b0;
      end
    endcase
    case(code[16])
      2'b00: begin
        mul_temp[16] = (ext_ina[31] & ext_ina[32] || ~ext_ina[31] & ~ext_ina[32]) ? 65'd0 : {ext_inb, 32'b0};
      end
      2'b01: begin
        mul_temp[16] = {ext_inb << 1, 32'b0};
      end
      2'b10: begin
        mul_temp[16] = {(~ext_inb + 1) << 1, 32'b0};
      end
      2'b11: begin
        mul_temp[16] = {~ext_inb + 1, 32'b0};
      end
      default: begin
        mul_temp[16] = 65'd0;
      end
    endcase
  end
  //Wallace Tree
  
  //level one
  wire signed [64:0] temp1_s [4:0];
  wire signed [64:0] carry [13:0];
  add unit0(.ina(mul_temp[16]), .inb(mul_temp[15]), .inc(mul_temp[14]), .s(temp1_s[0]), .c(carry[ 0]));
  add unit1(.ina(mul_temp[13]), .inb(mul_temp[12]), .inc(mul_temp[11]), .s(temp1_s[1]), .c(carry[ 1]));
  add unit2(.ina(mul_temp[10]), .inb(mul_temp[ 9]), .inc(mul_temp[ 8]), .s(temp1_s[2]), .c(carry[ 2]));
  add unit3(.ina(mul_temp[ 7]), .inb(mul_temp[ 6]), .inc(mul_temp[ 5]), .s(temp1_s[3]), .c(carry[ 3]));
  add unit4(.ina(mul_temp[ 4]), .inb(mul_temp[ 3]), .inc(mul_temp[ 2]), .s(temp1_s[4]), .c(carry[ 4]));

  //level two
  wire signed [64:0] temp2_s [3:0];
  add unit5(.ina(temp1_s[ 0]), .inb(temp1_s[ 1]), .inc(temp1_s[ 2]), .s(temp2_s[0]), .c(carry[ 5]));
  add unit6(.ina(temp1_s[ 3]), .inb(temp1_s[ 4]), .inc(mul_temp[ 1]), .s(temp2_s[1]), .c(carry[ 6]));
  add unit7(.ina(mul_temp[ 0]), .inb(carry[ 0]), .inc(carry[ 1]), .s(temp2_s[2]), .c(carry[ 7]));
  add unit8(.ina(carry[ 2]), .inb(carry[ 3]), .inc(carry[ 4]), .s(temp2_s[3]), .c(carry[ 8]));

  //level three
  wire signed [64:0] temp3_s [1:0];
  add  unit9(.ina(temp2_s[0]), .inb(temp2_s[1]), .inc(temp2_s[2]), .s(temp3_s[0]), .c(carry[ 9]));
  add unit10(.ina(temp2_s[3]), .inb(carry[ 5]), .inc(carry[ 6]), .s(temp3_s[1]), .c(carry[10]));

  //level four
  wire signed [64:0] temp4_s [1:0];
  add unit11(.ina(temp3_s[0]), .inb(temp3_s[1]), .inc(carry[7]), .s(temp4_s[0]), .c(carry[11]));
  add unit12(.ina(carry[8]), .inb(carry[9]), .inc(carry[10]), .s(temp4_s[1]), .c(carry[12]));
  
  reg signed [64:0] two_temp4_s [1:0];
  reg signed [64:0] carry1 [1:0];
  
  always @ (*) begin
    if (!resetn) begin
      two_temp4_s[0] <= 65'b0;
      two_temp4_s[1] <= 65'b0;
      carry1[0] <= 65'b0;
      carry1[1] <= 65'b0;
    end
    else begin
      two_temp4_s[0] <= temp4_s[0];
      two_temp4_s[1] <= temp4_s[1];
      carry1[0] <= carry[11];
      carry1[1] <= carry[12];
    end
  end

  //level five
  wire signed [64:0] temp5_s;
  wire signed [64:0] carry2;
  add unit13(.ina(two_temp4_s[0]), .inb(two_temp4_s[1]), .inc(carry1[0]), .s(temp5_s), .c(carry2));

  //level six
  wire signed [64:0] s;
  wire signed [64:0] c;
  add unit14(.ina(temp5_s), .inb(carry1[1]), .inc(carry2), .s(s), .c(c));

  assign result = s + c;
*/
//原来代码终止处

//  always @ (posedge clk, posedge resetn) begin
//    if (!resetn) begin
//      result <= 64'b0;
//    end
//    else begin
//      result <= out;
//    end
//  end
  
endmodule