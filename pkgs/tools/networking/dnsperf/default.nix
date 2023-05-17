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
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "DNS-OARC";
    repo = "dnsperf";
    rev = "v${version}";
    sha256 = "sha256-vZ2GPrlMHMe2vStjktbyLtXS5SoNzHbNwFi+CL1Z4VQ=";
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
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vcunat ];
  };
}
