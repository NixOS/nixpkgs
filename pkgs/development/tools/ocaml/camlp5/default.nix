{ lib, stdenv, fetchzip, ocaml, perl }:

if lib.versionOlder ocaml.version "4.02"
then throw "camlp5 is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {

  name = "camlp5-7.14";

  src = fetchzip {
    url = "https://github.com/camlp5/camlp5/archive/rel714.tar.gz";
    sha256 = "1dd68bisbpqn5lq2pslm582hxglcxnbkgfkwhdz67z4w9d5nvr7w";
  };

  buildInputs = [ ocaml perl ];

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
