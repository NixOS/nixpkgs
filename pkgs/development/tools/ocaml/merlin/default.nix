{ stdenv, fetchFromGitHub, buildDunePackage, yojson }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.3.2";

  minimumOCamlVersion = "4.02.1";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = "v${version}";
    sha256 = "1z9mcxflraj15sbz6q7f84n31n9fsialw7z8bi3r1biz68nypva9";
  };

  buildInputs = [ yojson ];

  meta = with stdenv.lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
