{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation {
  name = "procps-3.2.8";
  
  src = fetchurl {
    url = http://procps.sourceforge.net/procps-3.2.8.tar.gz;
    sha256 = "0d8mki0q4yamnkk4533kx8mc0jd879573srxhg6r2fs3lkc6iv8i";
  };
  
  patches =
    [ ./makefile.patch
      ./procps-build.patch
      ./gnumake3.82.patch
      ./linux-ver-init.patch
    ];
    
  buildInputs = [ ncurses ];
  
  makeFlags = "DESTDIR=$(out)";

  crossAttrs = {
    CC = stdenv.cross.config + "-gcc";
  };

  meta = {
    homepage = http://procps.sourceforge.net/;
    description = "Utilities that give information about processes using the /proc filesystem";
  };
}
