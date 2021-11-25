{ lib, fetchurl, fetchzip, callPackage }:

let mkOCamlformat = callPackage ./generic.nix; in

# Older versions should be removed when their usage decrease
# This script scraps Github looking for OCamlformat's options and versions usage:
#  https://gist.github.com/Julow/110dc94308d6078225e0665e3eccd433

rec {
  ocamlformat_0_11_0 = mkOCamlformat {
    version = "0.11.0";
  };

  ocamlformat_0_12 = mkOCamlformat {
    version = "0.12";
  };

  ocamlformat_0_13_0 = mkOCamlformat rec {
    version = "0.13.0";
    tarballName = "ocamlformat-${version}-2.tbz";
  };

  ocamlformat_0_14_0 = mkOCamlformat {
    version = "0.14.0";
  };

  ocamlformat_0_14_1 = mkOCamlformat {
    version = "0.14.1";
  };

  ocamlformat_0_14_2 = mkOCamlformat {
    version = "0.14.2";
  };

  ocamlformat_0_14_3 = mkOCamlformat {
    version = "0.14.3";
  };

  ocamlformat_0_15_0 = mkOCamlformat {
    version = "0.15.0";
  };

  ocamlformat_0_15_1 = mkOCamlformat {
    version = "0.15.1";
  };

  ocamlformat_0_16_0 = mkOCamlformat {
    version = "0.16.0";
  };

  ocamlformat_0_17_0 = mkOCamlformat {
    version = "0.17.0";
  };

  ocamlformat_0_18_0 = mkOCamlformat {
    version = "0.18.0";
  };

  ocamlformat_0_19_0 = mkOCamlformat {
    version = "0.19.0";
  };

  ocamlformat = ocamlformat_0_19_0;
}
