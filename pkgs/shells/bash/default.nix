{stdenv, fetchurl, bison, interactive ? false, ncurses ? null}:

assert interactive -> ncurses != null;

stdenv.mkDerivation {
  name = "bash-3.2-p25";

  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/bash-3.2-p25.tar.bz2;
    sha256 = "1x19z386ysvwk00zigzf3nkv1x1xq4kvyckz9ah8qz65a7626cs4";
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
