{ stdenv, fetchFromGitHub, libpcap, openssl, libnetfilter_queue, libnfnetlink }:
stdenv.mkDerivation rec {
  pname = "thc-ipv6";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "vanhauser-thc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xjg30z0wzm3xvccv9cgh000i1m79p3m8f0b3s741k0mzyrk8lln";
  };

  buildInputs = [
    libpcap
    openssl
    libnetfilter_queue
    libnfnetlink
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    description = "IPv6 attack toolkit";
    homepage = "https://github.com/vanhauser-thc/thc-ipv6";
    maintainers = with maintainers; [ ajs124 ];
    platforms = platforms.linux;
    license = licenses.agpl3Only;
  };
}
