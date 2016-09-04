{ stdenv, fetchFromGitHub, ocaml, findlib, ncurses }:

let version = "1.99.16-beta"; in

stdenv.mkDerivation {

  name = "ocp-build-${version}";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-build";
    rev = version;
    sha256 = "1nkd7wlf1vrc4p20bs94vbkd970q2ag23csh9a897ka65rk08gvw";
  };

  buildInputs = [ ocaml findlib ncurses ];
  preInstall = "mkdir -p $out/bin";

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
