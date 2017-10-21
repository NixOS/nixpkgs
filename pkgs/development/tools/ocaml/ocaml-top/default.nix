{ stdenv, fetchzip, ncurses
, ocamlPackages
, jbuilder }:

stdenv.mkDerivation {
  name = "ocaml-top-1.1.4";
  src = fetchzip {
    url = https://github.com/OCamlPro/ocaml-top/archive/1.1.4.tar.gz;
    sha256 = "1lmzjmnzsg8xdz0q5nm95zclihi9z80kzsalapg0s9wq0id8qm4j";
  };

  buildInputs = [ ncurses jbuilder ]
  ++ (with ocamlPackages; [ ocaml ocpBuild findlib lablgtk ocp-index ]);

  configurePhase = ''
    export TERM=xterm
    ocp-build -init
  '';

  buildPhase = "jbuilder build";

  inherit (jbuilder) installPhase;

  meta = {
    homepage = http://www.typerex.org/ocaml-top.html;
    license = stdenv.lib.licenses.gpl3;
    description = "A simple cross-platform OCaml code editor built for top-level evaluation";
    platforms = ocamlPackages.ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
