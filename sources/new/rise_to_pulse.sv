`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2024 11:02:43
// Design Name: 
// Module Name: rise_to_pulse
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rise_to_pulse (
    input logic clk,
    input logic reset,
    input logic in,
    output logic out
);

    // Registro para almacenar el estado anterior de "in"
    logic in_d;

    // Proceso secuencial para detectar flanco de subida
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            in_d <= 1'b0;
            out <= 1'b0;
        end else begin
            // Detecta el flanco de subida: `in` es 1 y `in_d` es 0
            out <= in && ~in_d;
            // Actualiza el registro del estado anterior
            in_d <= in;
        end
    end

endmodule
