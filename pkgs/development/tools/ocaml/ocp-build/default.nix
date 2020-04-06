{ stdenv, fetchpatch, fetchFromGitHub, ocaml, findlib, ncurses }:
let
  version = "1.99.19-beta";
in
stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-ocp-build-${version}";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocp-build";
    rev = version;
    sha256 = "162k5l0cxyqanxlml5v8mqapdq5qbqc9m4b8wdjq7mf523b3h2zj";
  };

  patches = stdenv.lib.optional (stdenv.lib.versionAtLeast ocaml.version "4.08") (fetchpatch {
    url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/ocp-pp/ocp-pp.1.99.19-beta/files/0001-Fix-ocp-pp-for-changes-in-compiler-libs.patch";
    sha256 = "0s0s2hh4d7cmwd6i7ixjgb79vij0r1v54m0vwwi26b3fips09qyn";
  });

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ ncurses ];
  preInstall = "mkdir -p $out/bin";
  preConfigure = ''
  export configureFlags="$configureFlags --with-metadir=$OCAMLFIND_DESTDIR"
  '';

  meta = with stdenv.lib; {
    homepage = https://www.typerex.org/ocp-build.html;
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
