{stdenv, fetchurl, bison, interactive ? false, ncurses ? null}:

assert interactive -> ncurses != null;

stdenv.mkDerivation {
  name = "bash-3.2-p17";

  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/bash-3.2-p17.tar.bz2;
    sha256 = "153gg2z2s3ar7vni3345nnmdisha4b8cxzsj79d8ap6m6i4c35f5";
  };

  postInstall = "ln -s bash $out/bin/sh";

  patches = [
    # For dietlibc builds.
    ./winsize.patch
  ];

  # !!! only needed for bash-3.2 (because of bash32-001.patch)
  buildInputs = [bison] ++ stdenv.lib.optional interactive ncurses;

  meta = {
    description =
      "GNU Bourne-Again Shell, the de facto standard shell on Linux" +
        (if interactive then " (for interactive use)" else "");
  };
}
