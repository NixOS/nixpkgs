{ lib, fetchzip, ncurses, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocaml-top";
  version = "1.2.0-rc";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocaml-top/archive/${version}.tar.gz";
    sha256 = "1r290m9vvr25lgaanivz05h0kf4fd3h5j61wj4hpp669zffcyyb5";
  };

  buildInputs = [ ncurses ocp-build lablgtk3-sourceview3 ocp-index ];

  configurePhase = ''
    export TERM=xterm
    ocp-build -init
  '';

  meta = {
    homepage = https://www.typerex.org/ocaml-top.html;
    license = lib.licenses.gpl3;
    description = "A simple cross-platform OCaml code editor built for top-level evaluation";
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
