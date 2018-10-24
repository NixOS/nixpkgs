{ stdenv, fetchFromGitHub
, openssl, zlib, readline, cmake, python }:

let
in stdenv.mkDerivation rec {
  version = "3.3.16";
  name    = "arangodb-${version}";

  src = fetchFromGitHub {
    repo = "arangodb";
    owner = "arangodb";
    rev = "v${version}";
    sha256 = "0pw930ri5a0f1s6mhsbjc58lsmpy535f5wv2vcp8mzdx1rk3l091";
  };

  buildInputs = [
    openssl zlib readline python
  ];

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    sed -ie 's!/bin/echo!echo!' 3rdParty/V8/v*/gypfiles/*.gypi
  '';

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
