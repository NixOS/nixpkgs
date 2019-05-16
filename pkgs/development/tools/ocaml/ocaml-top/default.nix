{ stdenv, fetchzip, ncurses, ocamlPackages }:

with ocamlPackages; buildDunePackage rec {
  pname = "ocaml-top";
  version = "1.1.5";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocaml-top/archive/${version}.tar.gz";
    sha256 = "1d4i6aanrafgrgk4mh154k6lkwk0b6mh66rykz33awlf5pfqd8yv";
  };

  buildInputs = [ ncurses ocp-build lablgtk ocp-index ];

  configurePhase = ''
    export TERM=xterm
    ocp-build -init
  '';

  meta = {
    homepage = https://www.typerex.org/ocaml-top.html;
    license = stdenv.lib.licenses.gpl3;
    description = "A simple cross-platform OCaml code editor built for top-level evaluation";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
