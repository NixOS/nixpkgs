{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "lzip-${version}";
  version = "1.21";

  nativeBuildInputs = [ texinfo ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${name}.tar.gz";
    sha256 = "12qdcw5k1cx77brv9yxi1h4dzwibhfmdpigrj43nfk8nscwm12z4";
  };

  configureFlags = [
    "CPPFLAGS=-DNDEBUG"
    "CFLAGS=-O3"
    "CXXFLAGS=-O3"
  ] ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    "CXX=${stdenv.cc.targetPrefix}c++";

  setupHook = ./lzip-setup-hook.sh;

  doCheck = true;
  enableParallelBuilding = true;

  meta = {
    homepage = https://www.nongnu.org/lzip/lzip.html;
    description = "A lossless data compressor based on the LZMA algorithm";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
