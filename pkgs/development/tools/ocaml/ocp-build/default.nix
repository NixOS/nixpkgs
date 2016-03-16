{ stdenv, fetchurl, ocaml, findlib, ncurses, camlp4 }:

stdenv.mkDerivation {

  name = "ocp-build-1.99.9-beta";

  src = fetchurl {
    url = http://www.typerex.org/pub/ocp-build/ocp-build.1.99.9-beta.tar.gz;
    sha256 = "0wcb49bp239ns9mz55ky0kfjcz80cp97k0j0rwaw4h5sp3phn4l0";
  };

  buildInputs = [ ocaml findlib ncurses camlp4 ];
  preInstall = "mkdir -p $out/bin";

  # In the Nix sandbox, the TERM variable is unset and stty does not
  # work. In such a case, ocp-build crashes due to a bug. The
  # ./fix-for-no-term.patch fixes this bug in the source code and hence
  # also in the final installed version of ocp-build. However, it does not
  # fix the bug in the precompiled bootstrap version of ocp-build that is
  # used during the compilation process. In order to bypass the bug until
  # it's also fixed upstream, we simply set TERM to some valid entry in the
  # terminfo database during the bootstrap.
  TERM = "xterm";

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
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
