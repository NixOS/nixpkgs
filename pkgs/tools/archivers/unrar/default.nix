{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "unrar-3.9.10";

  src = fetchurl {
    url = http://www.rarlab.com/rar/unrarsrc-3.9.10.tar.gz;
    sha256 = "0yi0i2j4srca8cag96ajc80m5xb5328ydzjab6y8h1bhypc2fiiv";
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
