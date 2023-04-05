{ lib, fetchFromGitHub, ncurses, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocaml-top";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocaml-top";
    rev = version;
    hash = "sha256-xmPGGB/zUpfeAxUIhR1PhfoESAJq7sTpqHuf++EH3Lw=";
  };

  nativeBuildInputs = [ ocp-build ];
  buildInputs = [ ncurses lablgtk3-sourceview3 ocp-index ];

  configurePhase = ''
    export TERM=xterm
    ocp-build -init
  '';

  meta = {
    homepage = "https://www.typerex.org/ocaml-top.html";
    license = lib.licenses.gpl3;
    description = "A simple cross-platform OCaml code editor built for top-level evaluation";
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
