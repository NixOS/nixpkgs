{ stdenv, fetchFromGitHub, ocamlPackages, reason }:

with ocamlPackages;

buildDunePackage rec {
  pname = "esy";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "esy";
    repo = "esy";
    rev = "v${version}";
    sha256 = "0n2606ci86vqs7sm8icf6077h5k6638909rxyj43lh55ah33l382";
  };

  buildInputs = [
    angstrom
    astring
    bos
    cmdliner
    cudf
    dose3
    fmt
    logs
    lwt_ppx
    opam-file-format
    opam-format
    opam-state
    ppx_deriving
    ppx_deriving_yojson
    ppx_expect
    ppx_here
    ppx_inline_test
    ppx_let
    ppx_sexp_conv
    ppxlib
    re
    reason
    rresult
    yojson
  ];

  meta = {
    description = "package.json workflow for native development with Reason/OCaml";
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.Zimmi48 ];
    homepage = "https://esy.sh";
  };
}
