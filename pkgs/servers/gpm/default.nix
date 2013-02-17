{ stdenv, fetchurl, flex, bison, ncurses }:

stdenv.mkDerivation rec {
  name = "gpm-1.20.6";
  
  src = fetchurl {
    url = "http://www.nico.schottelius.org/software/gpm/archives/${name}.tar.bz2";
    sha256 = "1990i19ddzn8gg5xwm53yn7d0mya885f48sd2hyvr7dvzyaw7ch8";
  };

  nativeBuildInputs = [ flex bison ];
  buildInputs = [ ncurses ];

  preConfigure =
    ''
      sed -e 's/[$](MKDIR)/mkdir -p /' -i doc/Makefile.in
    '';

  # Its configure script does not allow --disable-static
  # Disabling this, we make cross-builds easier, because having
  # cross-built static libraries we either have to disable stripping
  # or fixing the gpm users, because there -lgpm will fail.
  postInstall = ''
    rm -f $out/lib/*.a
    ln -s $out/lib/libgpm.so.2 $out/lib/libgpm.so
  '';

  meta = {
    homepage = http://www.nico.schottelius.org/software/gpm/;
    description = "A daemon that provides mouse support on the Linux console";
  };
}
