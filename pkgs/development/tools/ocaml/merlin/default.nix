{ stdenv, fetchFromGitHub, buildDunePackage, yojson }:

buildDunePackage rec {
  pname = "merlin";
  version = "3.3.0";

  minimumOCamlVersion = "4.02.1";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s4y7jz581hj4gqv4pkk3980khw4lm0qzcj416b4ckji40q7nf9d";
  };

  buildInputs = [ yojson ];

  meta = with stdenv.lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl ];
  };
}
