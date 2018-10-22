{ stdenv, fetchFromGitHub, ocamlPackages, dune }:

with ocamlPackages;

if !stdenv.lib.versionAtLeast ocaml.version "4.05"
then throw "ocamlformat is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.8";
  pname = "ocamlformat";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    sha256 = "1i7rsbs00p43362yv7z7dw0qsnv7vjf630qk676qvfg7kg422w6j";
  };

  buildInputs = [
    ocaml
    dune
    findlib
    base
    cmdliner
    fpath
    ocaml-migrate-parsetree
    stdio
  ];

  configurePhase = ''
    patchShebangs tools/gen_version.sh
    tools/gen_version.sh src/Version.ml version
  '';

  buildPhase = ''
    dune build -p ocamlformat
  '';

  inherit (dune) installPhase;

  meta = {
    homepage = "https://github.com/ocaml-ppx/ocamlformat";
    description = "Auto-formatter for OCaml code";
    maintainers = [ stdenv.lib.maintainers.Zimmi48 ];
    license = stdenv.lib.licenses.mit;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}
