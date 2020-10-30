{ stdenv, fetchFromGitHub, ocaml, findlib, ncurses, cmdliner, re }:
let
  version = "1.99.21";
in
stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-ocp-build-${version}-beta";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-build";
    rev = "v${version}";
    sha256 = "1641xzik98c7xnjwxpacijd6d9jzx340fmdn6i372z8h554jjlg9";
  };

  buildInputs = [ ocaml findlib cmdliner re ];
  propagatedBuildInputs = [ ncurses ];
  preInstall = "mkdir -p $out/bin";
  preConfigure = ''
  export configureFlags="$configureFlags --with-metadir=$OCAMLFIND_DESTDIR"
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.typerex.org/ocp-build.html";
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
