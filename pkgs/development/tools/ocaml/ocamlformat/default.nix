{ lib, fetchurl, fetchzip, callPackage }:

# Older versions should be removed when their usage decrease
# This script scraps Github looking for OCamlformat's options and versions usage:
#  https://gist.github.com/Julow/110dc94308d6078225e0665e3eccd433

rec {
  ocamlformat_0_19_0 = ocamlformat.override { version = "0.19.0"; };
  ocamlformat_0_20_0 = ocamlformat.override { version = "0.20.0"; };
  ocamlformat_0_20_1 = ocamlformat.override { version = "0.20.1"; };
  ocamlformat_0_21_0 = ocamlformat.override { version = "0.21.0"; };
  ocamlformat_0_22_4 = ocamlformat.override { version = "0.22.4"; };
  ocamlformat_0_23_0 = ocamlformat.override { version = "0.23.0"; };
  ocamlformat_0_24_1 = ocamlformat.override { version = "0.24.1"; };
  ocamlformat_0_25_1 = ocamlformat.override { version = "0.25.1"; };

  ocamlformat = callPackage ./generic.nix {};
}
