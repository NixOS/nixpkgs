{ lib, boringssl, stdenv, fetchgit, fetchFromGitHub, cmake, zlib, perl, libevent }:
let
  # lsquic requires a specific boringssl version (noted in its README)
  boringssl' = boringssl.overrideAttrs (old: rec {
    version = "251b5169fd44345f455438312ec4e18ae07fd58c";
    src = fetchgit {
      url = "https://boringssl.googlesource.com/boringssl";
      rev = version;
      sha256 = "sha256-EU6T9yQCdOLx98Io8o01rEsgxDFF/Xoy42LgPopD2/A=";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "lsquic";
  version = "2.18.1";

  src = fetchFromGitHub {
    owner = "litespeedtech";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hG8cUvhbCNeMOsKkaJlgGpzUrIx47E/WhmPIdI5F3qM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ boringssl' libevent zlib ];

  cmakeFlags = [
    "-DBORINGSSL_DIR=${boringssl'}"
    "-DBORINGSSL_LIB_crypto=${boringssl'}/lib/libcrypto.a"
    "-DBORINGSSL_LIB_ssl=${boringssl'}/lib/libssl.a"
    "-DZLIB_LIB=${zlib}/lib/libz.so"
  ];

  # adapted from lsquic.cr’s Dockerfile
  # (https://github.com/iv-org/lsquic.cr/blob/master/docker/Dockerfile)
  installPhase = ''
    runHook preInstall

    mkdir combinedlib
    cd combinedlib
    ar -x ${boringssl'}/lib/libssl.a
    ar -x ${boringssl'}/lib/libcrypto.a
    ar -x ../src/liblsquic/liblsquic.a
    ar rc liblsquic.a *.o
    ranlib liblsquic.a
    install -D liblsquic.a $out/lib/liblsquic.a

    runHook postInstall
  '';

  meta = with lib; {
    description = "A library for QUIC and HTTP/3 (version for Invidious)";
    homepage = "https://github.com/litespeedtech/lsquic";
    maintainers = with maintainers; [ infinisil sbruder ];
    license = with licenses; [ openssl isc mit bsd3 ]; # statically links against boringssl, so has to include its licenses
  };
}
