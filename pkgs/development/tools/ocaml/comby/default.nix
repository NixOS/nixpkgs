{ lib
, buildDunePackage
, fetchFromGitHub
, ocaml
, pkg-config
, pcre
, bisect_ppx
, camlzip
, core
, hack_parallel
, ocaml_lwt
, mparser
, opium
, patdiff
, ppx_deriving_yojson
, ppx_here
, ppx_let
, ppx_sexp_conv
, ppx_sexp_message
, ppx_tools_versioned
}:

buildDunePackage rec {
  pname = "comby";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "comby-tools";
    repo = pname;
    rev = version;
    sha256 = "15pyfal1y4djhq616s05f03ifwsh6l9l0wmh34jhhyks7zafvq3r";
  };

  useDune2 = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pcre
    bisect_ppx
    camlzip
    core
    hack_parallel
    ocaml_lwt
    mparser
    opium
    patdiff
    ppx_deriving_yojson
    ppx_here
    ppx_let
    ppx_sexp_conv
    ppx_sexp_message
    ppx_tools_versioned
  ];

  meta = with lib; {
    description = "A tool for structural code search and replace that supports ~every language";
    homepage = "https://github.com/comby-tools/comby";
    license = licenses.asl20;
    maintainers = with maintainers; [ filalex77 ];
  };
}
