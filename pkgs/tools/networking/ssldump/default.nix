{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, json_c
, libnet
, libpcap
, openssl
}:

stdenv.mkDerivation rec {
  pname = "ssldump";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "adulau";
    repo = "ssldump";
    rev = "v${version}";
    sha256 = "sha256-nk1sXQN9cPIZD7Xlg8CHmKySfvfWl2j0CGxmIyvA6z4=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    json_c
    libnet
    libpcap
    openssl
  ];

  prePatch = ''
    sed -i -e 's|#include.*net/bpf.h|#include <pcap/bpf.h>|' \
      base/pcap-snoop.c
  '';

  configureFlags = [
    "--with-pcap-lib=${libpcap}/lib"
    "--with-pcap-inc=${libpcap}/include"
    "--with-openssl-lib=${openssl}/lib"
    "--with-openssl-inc=${openssl}/include"
  ];

  meta = with lib; {
    description = "An SSLv3/TLS network protocol analyzer";
    homepage = "http://ssldump.sourceforge.net";
    license = "BSD-style";
    maintainers = with maintainers; [ aycanirican ];
    platforms = platforms.unix;
  };
}
