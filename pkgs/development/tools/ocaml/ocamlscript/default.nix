{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocamlscript";
  version = "3.0.0";
  src = fetchFromGitHub {
    owner = "mjambon";
    repo = "ocamlscript";
    rev = "v${version}";
    hash = "sha256-FN89XyNp60MhWvtCGW+3MqKECWhQ2TGEs49VaqdEv4M=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
  ];

  patches = [ ./Makefile.patch ];

  buildFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  preInstall = "mkdir -p $out/bin";
  createFindlibDestdir = true;

  meta = {
    inherit (src.meta) homepage;
    license = lib.licenses.boost;
    inherit (ocaml.meta) platforms;
    description = "Natively-compiled OCaml scripts";
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "ocamlscript";
    broken = !(lib.versionAtLeast ocaml.version "4.08");
  };
}
