// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

// The actual cache memory. This memory is made into a module
// to support multiple power domain needed by the floor plan tool

(* no_ungroup *)
(* no_boundary_optimization *)

module snitch_icache_data_serial #(
  parameter snitch_icache_pkg::config_t CFG = '0,
  /// Configuration input types for SRAMs used in implementation.
  parameter type sram_cfg_data_t    = logic
)(
  input  logic                                                clk_i,
  input  logic                                                rst_ni,
  input  sram_cfg_data_t                                      impl_i,
  output sram_cfg_data_t                                      impl_o,
  input  logic                                                req_i,
  input  logic                                                write_i,
  input  logic [$clog2(CFG.WAY_COUNT) + CFG.COUNT_ALIGN-1:0]  addr_i,
  input  logic [CFG.LINE_WIDTH-1:0]                           wdata_i,
  output logic [CFG.LINE_WIDTH-1:0]                           rdata_o
);

  tc_sram_impl #(
    .DataWidth ( CFG.LINE_WIDTH                 ),
    .NumWords  ( CFG.LINE_COUNT * CFG.WAY_COUNT ),
    .NumPorts  ( 1                              ),
    .impl_in_t ( sram_cfg_data_t                )
  ) i_data (
    .clk_i   ( clk_i        ),
    .rst_ni  ( rst_ni       ),
    .impl_i  ( impl_i       ),
    .impl_o  (              ),
    .req_i   ( req_i        ),
    .we_i    ( write_i      ),
    .addr_i  ( addr_i       ),
    .wdata_i ( wdata_i      ),
    .be_i    ( '1           ),
    .rdata_o ( rdata_o      )
  );

endmodule