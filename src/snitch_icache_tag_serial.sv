// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

// The actual cache memory. This memory is made into a module
// to support multiple power domain needed by the floor plan tool

(* no_ungroup *)
(* no_boundary_optimization *)

module snitch_icache_tag_serial #(
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
  input  logic [CFG.COUNT_ALIGN-1:0]                          addr_i,
  input  logic [CFG.WAY_COUNT*(CFG.TAG_WIDTH+2)-1:0]          wdata_i,
  input  logic [CFG.WAY_COUNT-1:0]                            be_i,
  output logic [CFG.WAY_COUNT*(CFG.TAG_WIDTH+2)-1:0]          rdata_o
);

  tc_sram_impl #(
    .DataWidth ( (CFG.TAG_WIDTH+2) * CFG.WAY_COUNT ),
    .ByteWidth ( CFG.TAG_WIDTH+2                   ),
    .NumWords  ( CFG.LINE_COUNT                    ),
    .NumPorts  ( 1                                 ),
    .impl_in_t ( sram_cfg_tag_t                    )
  ) i_data (
    .clk_i   ( clk_i        ),
    .rst_ni  ( rst_ni       ),
    .impl_i  ( impl_i       ),
    .impl_o  (              ),
    .req_i   ( req_i        ),
    .we_i    ( write_i      ),
    .addr_i  ( addr_i       ),
    .wdata_i ( wdata_i      ),
    .be_i    ( be_i         ),
    .rdata_o ( rdata_o      )
  );

endmodule
