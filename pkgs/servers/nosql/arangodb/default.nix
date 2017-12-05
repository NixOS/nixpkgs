{ stdenv, fetchFromGitHub, openssl, zlib, python2Packages, bash, go, readline }:

let
  inherit (python2Packages) python gyp;
in stdenv.mkDerivation rec {
  version = "2.5.3";
  name    = "arangodb-${version}";

  src = fetchFromGitHub {
    repo = "arangodb";
    owner = "arangodb";
    rev = "67d995aa22ea341129398326fa10c5f6c14e94e9";
    sha256 = "1v07fghf2jd2mvkfqhag0xblf6sxw7kx9kmhs2xpyrpns58lirvc";
  };

  postPatch = ''
    substituteInPlace 3rdParty/V8-3.31.74.1/build/gyp/gyp --replace /bin/bash ${bash}/bin/bash
    substituteInPlace 3rdParty/etcd/build --replace /bin/bash ${bash}/bin/bash
    sed '1i#include <cmath>' -i arangod/Aql/Functions.cpp \
      -i lib/Basics/string-buffer.cpp
  '';

  buildInputs = [
    openssl zlib python gyp go readline
  ];

  configureFlagsArray = [ "--with-openssl-lib=${openssl.out}/lib" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=strict-overflow";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/arangodb/arangodb;
    description = "A native multi-model database with flexible data models for documents, graphs, and key-values";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
  };
}
