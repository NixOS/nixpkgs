{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "lzip-${version}";
  version = "1.20";

  nativeBuildInputs = [ texinfo ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${name}.tar.gz";
    sha256 = "0319q59kb8g324wnj7xzbr7vvlx5bcs13lr34j0zb3kqlyjq2fy9";
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
    homepage = http://www.nongnu.org/lzip/lzip.html;
    description = "A lossless data compressor based on the LZMA algorithm";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.all;
  };
}
