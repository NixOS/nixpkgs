{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, ldns
, libck
, nghttp2
, openssl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "dnsperf";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "DNS-OARC";
    repo = "dnsperf";
    rev = "v${version}";
    hash = "sha256-iNTuLcN9bsBPyXZ8SL96moFaI2pTcEhFey8+4xo9iyk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ldns # optional for DDNS (but cheap anyway)
    libck
    nghttp2
    openssl
  ];

  doCheck = true;

  meta = with lib; {
    description = "Tools for DNS benchmaring";
    homepage = "https://www.dns-oarc.net/tools/dnsperf";
    changelog = "https://github.com/DNS-OARC/dnsperf/releases/tag/v${version}";
    license = licenses.isc;
    platforms = platforms.unix;
    mainProgram = "dnsperf";
    maintainers = with maintainers; [ vcunat mfrw ];
  };
}
