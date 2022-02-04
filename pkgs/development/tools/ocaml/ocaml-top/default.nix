{ lib, fetchFromGitHub, ncurses, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocaml-top";
  version = "1.2.0-rc";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocaml-top";
    rev = version;
    sha256 = "sha256-ZXnPnPvJmHshkTwYWeBojrgJYAF/R6vUo0XkvVMFSeQ=";
  };

  buildInputs = [ ncurses ocp-build lablgtk3-sourceview3 ocp-index ];

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
