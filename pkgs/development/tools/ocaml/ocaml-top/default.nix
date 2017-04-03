{ stdenv, fetchzip, ncurses
, ocamlPackages
, opam }:

stdenv.mkDerivation {
  name = "ocaml-top-1.1.3";
  src = fetchzip {
    url = https://github.com/OCamlPro/ocaml-top/archive/1.1.3.tar.gz;
    sha256 = "0islyinv7lwhg8hkg4xn30wwz1nv50rj0wpsis8jpimw6jdsnax3";
  };

  buildInputs = [ ncurses opam ]
  ++ (with ocamlPackages; [ ocaml ocpBuild findlib lablgtk ocp-index ]);

  configurePhase = ''
    export TERM=xterm
    ocp-build -init
  '';

  buildPhase = "ocp-build ocaml-top";

  installPhase = "opam-installer --prefix=$out";

  meta = {
    homepage = http://www.typerex.org/ocaml-top.html;
    license = stdenv.lib.licenses.gpl3;
    description = "A simple cross-platform OCaml code editor built for top-level evaluation";
    platforms = ocamlPackages.ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
