{stdenv, fetchurl, bison}:

stdenv.mkDerivation {
  name = "bash-3.2";

  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/bash/bash-3.2.tar.gz;
    md5 = "00bfa16d58e034e3c2aa27f390390d30";
  };

  postInstall = "ln -s bash $out/bin/sh";

  patches = [
    # Fix a nasty bug in bash-3.2.
    ./bash32-001.patch
  
    # For dietlibc builds.
    ./winsize.patch
  ];

  # !!! only needed for bash-3.2 (because of bash32-001.patch)
  buildInputs = [bison]; 

  meta = {
    description = "GNU Bourne-Again Shell, the de facto standard shell on Linux";
  };
}
