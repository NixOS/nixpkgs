{ stdenv, fetchFromGitHub, buildDunePackage, yojson }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.3.1";

  minimumOCamlVersion = "4.02.1";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z2m6jykgn3nylh4bfirhxlb0bwamifv4fgml6j34ggk1drs8xrl";
  };

  buildInputs = [ yojson ];

  meta = with stdenv.lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
