{ lib, stdenv, fetchFromGitHub, ocaml, perl }:

if lib.versionOlder ocaml.version "4.02"
|| lib.versionOlder "4.13" ocaml.version
then throw "camlp5 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {

  pname = "camlp5";
  version = "7.14";

  src = fetchFromGitHub {
    owner = "camlp5";
    repo = "camlp5";
    rev = "rel${builtins.replaceStrings [ "." ] [ "" ] version}";
    sha256 = "1dd68bisbpqn5lq2pslm582hxglcxnbkgfkwhdz67z4w9d5nvr7w";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocaml perl ];

  prefixKey = "-prefix ";

  preConfigure = ''
    configureFlagsArray=(--strict --libdir $out/lib/ocaml/${ocaml.version}/site-lib)
    patchShebangs ./config/find_stuffversion.pl
  '';

  buildFlags = [ "world.opt" ];

  dontStrip = true;

  meta = with lib; {
    description = "Preprocessor-pretty-printer for OCaml";
    longDescription = ''
      Camlp5 is a preprocessor and pretty-printer for OCaml programs.
      It also provides parsing and printing tools.
    '';
    homepage = "https://camlp5.github.io/";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      maggesi vbgl
    ];
  };
}
