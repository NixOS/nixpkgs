{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "unrar-3.9.7";

  src = fetchurl {
    url = http://www.rarlab.com/rar/unrarsrc-3.9.7.tar.gz;
    sha256 = "101w7fgfr5biyic8gj0km5aqi4xj8dikh4aa0rx0qvg8bjp19wb4";
  };

  # Add a missing objects to the library
  #patchPhase = ''
  #  sed -i 's/^\(LIB_OBJ=.*\)/\1 recvol.o rs.o/' makefile.unix
  #'';

  buildPhase = ''
    make -f makefile.unix unrar
    rm *.o
    make -f makefile.unix lib CXXFLAGS="-fPIC -O2 -DSILENT";
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp unrar $out/bin
    cp libunrar.so $out/lib
  '';

  buildInputs = [];
}
