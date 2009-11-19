{ stdenv, fetchurl, flex, bison, ncurses }:

stdenv.mkDerivation rec {
  name = "gpm-1.20.6";
  
  src = fetchurl {
    url = "http://www.nico.schottelius.org/software/gpm/archives/${name}.tar.bz2";
    sha256 = "1990i19ddzn8gg5xwm53yn7d0mya885f48sd2hyvr7dvzyaw7ch8";
  };

  buildInputs = [ flex bison ncurses ];

  preConfigure =
    ''
      sed -e 's/[$](MKDIR)/mkdir -p /' -i doc/Makefile.in
    '';
      
  meta = {
    homepage = http://www.nico.schottelius.org/software/gpm/;
    description = "A daemon that provides mouse support on the Linux console";
  };
}
