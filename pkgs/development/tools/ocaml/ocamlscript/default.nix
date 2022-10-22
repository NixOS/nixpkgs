{ lib, stdenv, fetchFromGitHub, ocaml, findlib }:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.08")
  "ocamlscript is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-ocamlscript";
  version = "3.0.0";
  src = fetchFromGitHub {
    owner = "mjambon";
    repo = "ocamlscript";
    rev = "v${version}";
    sha256 = "sha256:10xz8jknlmcgnf233nahd04q98ijnxpijhpvb8hl7sv94dgkvpql";
  };

  propagatedBuildInputs = [ ocaml findlib ];

  patches = [ ./Makefile.patch ];

  buildFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  preInstall = "mkdir -p $out/bin";
  createFindlibDestdir = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    license = licenses.boost;
    inherit (ocaml.meta) platforms;
    description = "Natively-compiled OCaml scripts";
    maintainers = [ maintainers.vbgl ];
    mainProgram = "ocamlscript";
  };
}
