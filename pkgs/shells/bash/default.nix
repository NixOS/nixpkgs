{stdenv, fetchurl, bison, interactive ? false, ncurses ? null}:

assert interactive -> ncurses != null;

stdenv.mkDerivation {
  name = "bash-3.2-p33";

  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/bash-3.2-p33.tar.bz2;
    sha256 = "11fv73nbcckmm4f1q9cf73754chsgfps9pklwcaj2ryfd5ql9wnb";
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
