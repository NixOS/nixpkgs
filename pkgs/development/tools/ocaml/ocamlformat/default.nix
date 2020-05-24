{ lib, fetchurl, ocamlPackages }:

with ocamlPackages;

let
  mkOCamlformat = {
      version,
      sha256,
      buildInputs,
      useDune2 ? true,
      tarballName ? "ocamlformat-${version}.tbz",
      # The 'url' argument can be removed when 0.11.0 is pruned
      url ? "https://github.com/ocaml-ppx/ocamlformat/releases/download/${version}/${tarballName}"
    }:
    buildDunePackage rec {
      pname = "ocamlformat";

      minimumOCamlVersion = "4.06";

      src = fetchurl {
        inherit url sha256;
      };

      inherit version useDune2 buildInputs;

      meta = {
        inherit (src.meta) homepage;
        description = "Auto-formatter for OCaml code";
        maintainers = [ lib.maintainers.Zimmi48 lib.maintainers.marsam ];
        license = lib.licenses.mit;
      };
    };

  post_0_11_buildInputs = [
    base
    cmdliner
    fpath
    ocaml-migrate-parsetree
    odoc
    re
    stdio
    uuseg
    uutf
  ];

  post_0_14_buildInputs = [
    base
    cmdliner
    fpath
    ocaml-migrate-parsetree
    odoc
    re
    stdio
    uuseg
    uutf
    fix
    menhir
  ];
in

rec {
  ocamlformat_0_11_0 = mkOCamlformat {
    version = "0.11.0";
    url = "https://github.com/ocaml-ppx/ocamlformat/archive/0.11.0.tar.gz";
    sha256 = "0bl3c7b40wz5slnzcbbjimrnphhgk03vvm8bbb60ybp1k1jyr5lw";
    useDune2 = false;
    buildInputs = post_0_11_buildInputs;
  };

  ocamlformat_0_12 = mkOCamlformat {
    version = "0.12";
    sha256 = "1zi8x597dhp2822j6j28s84yyiqppl7kykpwqqclx6ybypvlzdpj";
    useDune2 = false;
    buildInputs = post_0_11_buildInputs;
  };

  ocamlformat_0_13_0 = mkOCamlformat rec {
    version = "0.13.0";
    sha256 = "0ki2flqi3xkhw9mfridivb6laxm7gml8rj9qz42vqmy9yx76jjxq";
    tarballName = "ocamlformat-${version}-2.tbz";
    useDune2 = false;
    buildInputs = post_0_11_buildInputs;
  };

  ocamlformat_0_14_0 = mkOCamlformat {
    version = "0.14.0";
    sha256 = "070c0x6z5y0lyls56zm34g8lyc093wkr0jfp50dvrkr9fk1sx2wi";
    buildInputs = post_0_14_buildInputs;
  };

  ocamlformat_0_14_1 = mkOCamlformat {
    version = "0.14.1";
    sha256 = "03wn46xib63748157xchj7gflkw5000fcjw6n89h9g82q9slazaa";
    buildInputs = post_0_14_buildInputs;
  };

  ocamlformat_0_14_2 = mkOCamlformat {
    version = "0.14.2";
    sha256 = "16phz1sg9b070p6fm8d42j0piizg05vghdjmw8aj7xm82b1pm7sz";
    buildInputs = post_0_14_buildInputs;
  };

  ocamlformat_0_15_0 = mkOCamlformat {
    version = "0.15.0";
    sha256 = "0190vz59n6ma9ca1m3syl3mc8i1smj1m3d8x1jp21f710y4llfr6";
    buildInputs = post_0_14_buildInputs;
  };

  ocamlformat = ocamlformat_0_15_0;
}
