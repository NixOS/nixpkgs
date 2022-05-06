{ lib, boringssl, stdenv, fetchgit, fetchFromGitHub, cmake, zlib, perl, libevent }:
let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);

  # lsquic requires a specific boringssl version (noted in its README)
  boringssl' = boringssl.overrideAttrs (old: {
    version = versions.boringssl.rev;
    src = fetchgit {
      url = "https://boringssl.googlesource.com/boringssl";
      inherit (versions.boringssl) rev sha256;
    };

    patches = [
      # Use /etc/ssl/certs/ca-certificates.crt instead of /etc/ssl/cert.pem
      ./use-etc-ssl-certs.patch
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "lsquic";
  version = versions.lsquic.version;

  src = fetchFromGitHub {
    owner = "litespeedtech";
    repo = pname;
    rev = "v${version}";
    inherit (versions.lsquic) sha256;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ boringssl' libevent zlib ];

  cmakeFlags = [
    "-DBORINGSSL_DIR=${lib.getDev boringssl'}"
    "-DBORINGSSL_LIB_crypto=${lib.getLib boringssl'}/lib/libcrypto.a"
    "-DBORINGSSL_LIB_ssl=${lib.getLib boringssl'}/lib/libssl.a"
    "-DZLIB_LIB=${zlib}/lib/libz.so"
  ];

  # adapted from lsquic.cr’s Dockerfile
  # (https://github.com/iv-org/lsquic.cr/blob/master/docker/Dockerfile)
  installPhase = ''
    runHook preInstall

    mkdir combinedlib
    cd combinedlib
    ar -x ${lib.getLib boringssl'}/lib/libssl.a
    ar -x ${lib.getLib boringssl'}/lib/libcrypto.a
    ar -x ../src/liblsquic/liblsquic.a
    ar rc liblsquic.a *.o
    ranlib liblsquic.a
    install -D liblsquic.a $out/lib/liblsquic.a

    runHook postInstall
  '';

  passthru.boringssl = boringssl';

  meta = with lib; {
    description = "A library for QUIC and HTTP/3 (version for Invidious)";
    homepage = "https://github.com/litespeedtech/lsquic";
    maintainers = with maintainers; [ infinisil sbruder ];
    license = with licenses; [ openssl isc mit bsd3 ]; # statically links against boringssl, so has to include its licenses
  };
}
