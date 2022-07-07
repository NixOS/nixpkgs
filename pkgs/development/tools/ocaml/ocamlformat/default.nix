{ lib, fetchurl, fetchzip, callPackage }:

let mkOCamlformat = callPackage ./generic.nix; in

# Older versions should be removed when their usage decrease
# This script scraps Github looking for OCamlformat's options and versions usage:
#  https://gist.github.com/Julow/110dc94308d6078225e0665e3eccd433

rec {
  ocamlformat_0_19_0 = mkOCamlformat {
    version = "0.19.0";
  };

  ocamlformat_0_20_0 = mkOCamlformat {
    version = "0.20.0";
  };

  ocamlformat_0_20_1 = mkOCamlformat {
    version = "0.20.1";
  };

  ocamlformat_0_21_0 = mkOCamlformat {
    version = "0.21.0";
  };

  ocamlformat_0_22_4 = mkOCamlformat {
    version = "0.22.4";
  };

  ocamlformat_0_23_0 = mkOCamlformat {
    version = "0.23.0";
  };

  ocamlformat = ocamlformat_0_23_0;
}
