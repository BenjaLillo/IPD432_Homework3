module sync_enables (
    input  logic clk_src,          // Reloj del dominio fuente
    input  logic clk_dst,          // Reloj del dominio destino
    input  logic resetN,           // Reset activo bajo
    input  logic [2:0] signal_in,  // Señales a sincronizar desde clk_src
    output logic [2:0] signal_out  // Señales sincronizadas hacia clk_dst
);

    // Etapa de registro en el dominio fuente
    logic [2:0] signal_src_reg;

    always_ff @(posedge clk_src or negedge resetN) begin
        if (!resetN) begin
            signal_src_reg <= 0;
        end else begin
            signal_src_reg <= signal_in;
        end
    end

    // Etapas de sincronización en el dominio destino
    logic [2:0] signal_stage1, signal_stage2;

    always_ff @(posedge clk_dst or negedge resetN) begin
        if (!resetN) begin
            signal_stage1 <= 0;
            signal_stage2 <= 0;
        end else begin
            signal_stage1 <= signal_src_reg;
            signal_stage2 <= signal_stage1;
        end
    end

    // Salida final sincronizada
    assign signal_out = signal_stage2;

endmodule