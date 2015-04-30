{ stdenv, fetchgit, openssl, zlib, python, gyp, bash, go, readline }:

stdenv.mkDerivation rec {
  version = "2.5.2";
  name    = "arangodb-${version}";

  src = fetchgit {
    url = https://github.com/arangodb/arangodb.git;
    rev = "refs/tags/v${version}";
    sha256 = "04l9palmh0jwbylapsss7d1s0h54wb6kng30zqsl3dq9l91ii6s0";
  };

  buildInputs = [
    openssl zlib python gyp go readline
  ];

  configureFlagsArray = [ "--with-openssl-lib=${openssl}/lib" ];

  patchPhase = ''
    substituteInPlace 3rdParty/V8-3.31.74.1/build/gyp/gyp --replace /bin/bash ${bash}/bin/bash
    substituteInPlace 3rdParty/etcd/build --replace /bin/bash ${bash}/bin/bash
    '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/arangodb/arangodb";
    description = "A native multi-model database with flexible data models for documents, graphs, and key-values";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
  };
}
