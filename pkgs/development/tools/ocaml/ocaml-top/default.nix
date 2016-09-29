{ stdenv, fetchzip, ncurses
, ocaml, ocpBuild, findlib, lablgtk, ocp-index
, opam }:

stdenv.mkDerivation {
  name = "ocaml-top-1.1.2";
  src = fetchzip {
    url = https://github.com/OCamlPro/ocaml-top/archive/1.1.2.tar.gz;
    sha256 = "10wfz8d6c1lbh31kayvlb5fj7qmgh5c6xhs3q595dnf9skrf091j";
  };

  buildInputs = [ ncurses opam ocaml ocpBuild findlib lablgtk ocp-index ];

  configurePhase = ''
    export TERM=xterm
    ocp-build -init
  '';

  buildPhase = "ocp-build ocaml-top";

  installPhase = ''
    opam-installer --script --prefix=$out ocaml-top.install | sh
  '';

  meta = {
    homepage = http://www.typerex.org/ocaml-top.html;
    license = stdenv.lib.licenses.gpl3;
    description = "A simple cross-platform OCaml code editor built for top-level evaluation";
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
