# pkgs/pkgs_lib/default.nix
# ------------------------------------------------------------------------------
# 📘 Purpose:
# The pkgs-lib module provides functions and values that cannot be placed in
# `lib/` because they have runtime dependencies on packages (`pkgs`).
#
# Unlike `pkgs/build-support`, this library is not meant for supporting the
# package build process itself, but rather for utilities and helpers that
# **consume built packages** (for example, format generators or renderers).
#
# ------------------------------------------------------------------------------
# 🧩 Design Notes:
# - `pkgs_lib` serves as an extension layer over `lib`, allowing access to
#   higher-level functionality that depends on actual Nix packages.
# - Any functionality defined here should remain deterministic and
#   reproducible across systems.
# - Functions requiring compilation, build inputs, or sandboxing should
#   belong in `pkgs/build-support` instead.
#
# ------------------------------------------------------------------------------
# ⚙️ Parameters:
# - `lib`: The base functional library from nixpkgs (pure, package-independent utilities)
# - `pkgs`: The full Nixpkgs package set, used for rendering, conversions, etc.
#
# ------------------------------------------------------------------------------
# 📦 Exports:
# - `formats`: A set of format renderers and generators for structured outputs
#   (e.g., JSON, YAML, TOML, etc.), relying on package-based tooling.
#
# ------------------------------------------------------------------------------
{ lib, pkgs }:

{
  # 🧰 Formats:
  # Defines structured format generators that depend on `pkgs` for rendering.
  # These cannot be placed in `lib/types.nix` because they rely on external
  # package tools for correct output serialization.
  formats = import ./formats.nix {
    inherit lib pkgs;
  };
}
