{ stdenv, fetchFromGitHub, ocaml, findlib, ncurses, buildOcaml }:
let
  version = "1.99.17-beta";
in
buildOcaml {

  name = "ocp-build";
  inherit version;

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-build";
    rev = version;
    sha256 = "0k1gi5v9as5l8h5illgl5prsd5z1i14y5j2k920ay1a3rv697b02";
  };

  buildInputs = [ ocaml ];
  propagatedBuildInputs = [ ncurses ];
  preInstall = "mkdir -p $out/bin";
  preConfigure = ''
  export configureFlags="$configureFlags --with-metadir=$OCAMLFIND_DESTDIR"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.typerex.org/ocp-build.html;
    description = "A build tool for OCaml";
    longDescription = ''
      ocp-build is a build system for OCaml application, based on simple
      descriptions of packages. ocp-build combines the descriptions of
      packages, and optimize the parallel compilation of files depending on
      the number of cores and the automatically-inferred dependencies
      between source files.
    '';
    license = licenses.gpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.jirkamarsik ];
  };
}
