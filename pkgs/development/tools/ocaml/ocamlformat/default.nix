{ stdenv, fetchFromGitHub, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocamlformat";
  version = "0.8";

  minimumOCamlVersion = "4.05";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    sha256 = "1i7rsbs00p43362yv7z7dw0qsnv7vjf630qk676qvfg7kg422w6j";
  };

  buildInputs = [
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

  meta = {
    inherit (src.meta) homepage;
    description = "Auto-formatter for OCaml code";
    maintainers = [ stdenv.lib.maintainers.Zimmi48 ];
    license = stdenv.lib.licenses.mit;
  };
}
