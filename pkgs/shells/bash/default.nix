{stdenv, fetchurl, bison, interactive ? false, ncurses ? null}:

assert interactive -> ncurses != null;

stdenv.mkDerivation {
  name = "bash-3.2-p39";

  src = fetchurl {
    url = http://nixos.org/tarballs/bash-3.2-p39.tar.bz2;
    sha256 = "075qs6nfjql57y8ffg3f4glb3l5yl3xy5hny75x6kpwxkqlcxqfy";
  };

  postInstall = "ln -s bash $out/bin/sh";

  patches = [
    # For dietlibc builds.
    ./winsize.patch
  ];

  # !!! only needed for bash-3.2 (because of bash32-001.patch)
  buildInputs = [bison] ++ stdenv.lib.optional interactive ncurses;

  meta = {
    homepage = http://www.gnu.org/software/bash/;
    description =
      "GNU Bourne-Again Shell, the de facto standard shell on Linux" +
        (if interactive then " (for interactive use)" else "");
  };
}
