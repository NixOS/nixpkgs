{ lib, fetchFromGitHub, ocamlPackages, menhir }:

ocamlPackages.buildDunePackage rec {
  pname = "obelisk";
  version = "0.6.0";
  duneVersion = "3";
  src = fetchFromGitHub {
    owner = "Lelio-Brun";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jjaqa2b7msl9qd3x7j34vdh1s9alq8hbvzk8a5srb4yyfyim15b";
  };

  strictDeps = true;

  nativeBuildInputs = [ menhir ];
  buildInputs = with ocamlPackages; [ re ];

  meta = {
    description = "A simple tool which produces pretty-printed output from a Menhir parser file (.mly)";
    mainProgram = "obelisk";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/Lelio-Brun/Obelisk";
  };
}
