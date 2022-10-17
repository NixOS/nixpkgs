{ lib, stdenv, fetchFromGitHub, ocaml }:

stdenv.mkDerivation rec {
  pname = "obuild";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "ocaml-obuild";
    repo = "obuild";
    rev = "obuild-v${version}";
    sha256 = "sha256-dqWP9rwWmr7i3O29v/kipJL01B3qQozaToOFCdfTWZU=";
  };

  buildInputs = [ ocaml ];

  buildPhase = ''
    patchShebangs ./bootstrap
    ./bootstrap
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp dist/build/obuild/obuild dist/build/obuild-from-oasis/obuild-from-oasis dist/build/obuild-simple/obuild-simple $out/bin/
  '';

  meta = {
    homepage = "https://github.com/ocaml-obuild/obuild";
    platforms = ocaml.meta.platforms or [ ];
    description = "Simple package build system for OCaml";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ ];
  };
}
