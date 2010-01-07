{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "unrar-3.7.6";

  src = fetchurl {
    url = http://www.rarlab.com/rar/unrarsrc-3.7.6.tar.gz;
    sha256 = "0inzy0jlwqm18i6lq17aq4n2baqqlbjyr6incw4s9cxrvmjq51ls";
  };

  buildPhase = "make -f makefile.unix unrar lib CXXFLAGS=\"-fPIC -O2\"";

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp unrar $out/bin
    cp libunrar.so $out/lib
  '';

  buildInputs = [];
}
