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
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "DNS-OARC";
    repo = "dnsperf";
    rev = "v${version}";
    sha256 = "sha256-TWFi3oPTIKjBaw0Rq0AfZgxyVukvL2SWa2qvWw2WAQ4=";
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
