{ lib, stdenv, fetchFromGitHub, openssl, libevent, libpcap, libnet, zlib }:

stdenv.mkDerivation rec {
  pname = "sslsplit";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "droe";
    repo = pname;
    rev = version;
    sha256 = "1p43z9ln5rbc76v0j1k3r4nhvfw71hq8jzsallb54z9hvwfvqp3l";
  };

  buildInputs = [ openssl libevent libpcap libnet zlib ];

  makeFlags = [
    "PREFIX=$(out)"
    "OPENSSL_BASE=${openssl.dev}"
    "LIBEVENT_BASE=${libevent.dev}"
    "LIBPCAP_BASE=${libpcap}"
    "LIBNET_BASE=${libnet}"
  ];

  meta = with lib; {
    description = "Transparent SSL/TLS interception";
    homepage = "https://www.roe.ch/SSLsplit";
    platforms = platforms.all;
    maintainers = with maintainers; [ contrun ];
    license = with licenses; [ bsd2 mit unlicense free ];
  };
}
