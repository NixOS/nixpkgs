{ stdenv, fetchzip, buildDunePackage, yojson }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.2.2";

  minimumOCamlVersion = "4.02";

  src = fetchzip {
    url = "https://github.com/ocaml/merlin/archive/v${version}.tar.gz";
    sha256 = "15ssgmwdxylbwhld9p1cq8x6kadxyhll5bfyf11dddj6cldna3hb";
  };

  buildInputs = [ yojson ];

  meta = with stdenv.lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
