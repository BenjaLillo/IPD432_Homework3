`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// xxx
//////////////////////////////////////////////////////////////////////////////////

module adder_tree #(
    parameter N = 8,  // Input number
    parameter I = 8   // Input width
    )(
    input  logic [N-1:0][I-1:0] d,  // Input vector
    output logic [31:0] q          // 32-bits output vector
    );
    
    localparam ETAPAS = $clog2(N);
    localparam INICIO = 2**ETAPAS;
    localparam Nsum = INICIO-1;
    localparam Wsum = I + ETAPAS;
    logic [Nsum-1:0][Wsum-1:0] sum;
    
    int prev;
    int curr; 
    int sum_number;
    
    always_comb begin
            sum_number = INICIO/2;
            for (int j=0 ; j<sum_number ; j++) begin
                if      (2*j+1 < N) sum[j] = d[2*j] + d[2*j+1];
                else if (2*j < N)   sum[j] = d[2*j];
                else                sum[j] = 0;
            end
            prev = 0;
            curr = sum_number;
            sum_number = sum_number/2;
            for (int i=1 ; i<ETAPAS ; i++) begin
                for (int j=0 ; j<sum_number ; j++) begin
                    sum[curr + j] = sum[prev + 2*j] + sum[prev + 2*j + 1];
                end
                prev = curr;
                curr = curr + sum_number;
                sum_number = sum_number/2;
            end 
            q = sum[Nsum-1];
    end
    
    
endmodule