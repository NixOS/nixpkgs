{ stdenv, fetchzip, ncurses
, ocamlPackages
, dune
}:

stdenv.mkDerivation rec {
  version = "1.1.5";
  name = "ocaml-top-${version}";
  src = fetchzip {
    url = "https://github.com/OCamlPro/ocaml-top/archive/${version}.tar.gz";
    sha256 = "1d4i6aanrafgrgk4mh154k6lkwk0b6mh66rykz33awlf5pfqd8yv";
  };

  buildInputs = [ ncurses dune ]
  ++ (with ocamlPackages; [ ocaml ocp-build findlib lablgtk ocp-index ]);

  configurePhase = ''
    export TERM=xterm
    ocp-build -init
  '';

  buildPhase = "jbuilder build";

  inherit (dune) installPhase;

  meta = {
    homepage = https://www.typerex.org/ocaml-top.html;
    license = stdenv.lib.licenses.gpl3;
    description = "A simple cross-platform OCaml code editor built for top-level evaluation";
    platforms = ocamlPackages.ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
