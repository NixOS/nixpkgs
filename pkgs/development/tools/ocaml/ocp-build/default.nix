{ stdenv, fetchurl, ocaml, findlib, ncurses }:

stdenv.mkDerivation {

  name = "ocp-build-1.99.8-beta";

  src = fetchurl {
    url = "https://github.com/OCamlPro/ocp-build/archive/ocp-build.1.99.8-beta.tar.gz";
    sha256 = "06qh8v7k5m52xbivas08lblspsnvdl0vd7ghfj6wvpnfl8qvqabn";
  };

  buildInputs = [ ocaml findlib ncurses ];

  patches = [ ./fix-for-no-term.patch ];

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
    homepage = "http://typerex.ocamlpro.com/ocp-build.html";
    description = "A build tool for OCaml";
    longDescription = ''
      ocp-build is a build system for OCaml application, based on simple
      descriptions of packages. ocp-build combines the descriptions of
      packages, and optimize the parallel compilation of files depending on
      the number of cores and the automatically-infered dependencies
      between source files.
    '';
    license = licenses.gpl3;
    platforms = ocaml.meta.platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
