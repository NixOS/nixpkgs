{stdenv, fetchurl, bison, interactive ? false, ncurses ? null, texinfo ? null}:

assert interactive -> ncurses != null;

stdenv.mkDerivation {
  name = "bash-3.2.48";

  src = fetchurl {
    url = mirror://gnu/bash/bash-3.2.48.tar.gz;
    sha256 = "1i81scw3mnfjbmsn3cjfdancyx3d0rg8gd9hpdfng9j83dbdrs98";
  };

  NIX_CFLAGS_COMPILE = ''
    -DSYS_BASHRC="/etc/bashrc"
    -DSYS_BASH_LOGOUT="/etc/bash_logout"
    -DDEFAULT_PATH_VALUE="/no-such-path"
    -DSTANDARD_UTILS_PATH="/no-such-path"
    -DNON_INTERACTIVE_LOGIN_SHELLS
    -DSSH_SOURCE_BASHRC
  '';

  postInstall = "ln -s bash $out/bin/sh";

  patches = [
    # For dietlibc builds.
    ./winsize.patch
  ];

  # !!! Bison is only needed for bash-3.2 (because of bash32-001.patch)
  buildInputs = [bison]
    ++ stdenv.lib.optional (texinfo != null) texinfo
    ++ stdenv.lib.optional interactive ncurses;

  meta = {
    homepage = http://www.gnu.org/software/bash/;
    description =
      "GNU Bourne-Again Shell, the de facto standard shell on Linux" +
        (if interactive then " (for interactive use)" else "");
  };
}
