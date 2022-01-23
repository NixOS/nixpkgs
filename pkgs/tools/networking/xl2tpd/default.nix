{ lib, stdenv, fetchFromGitHub, libpcap, ppp }:

stdenv.mkDerivation rec {
  pname = "xl2tpd";
  version = "1.3.17";

  src = fetchFromGitHub {
    owner = "xelerance";
    repo = "xl2tpd";
    rev = "v${version}";
    sha256 = "sha256-ibHiQn6YBd80rXIxZeUSTNs9KOJXVGRlUIr753mLURk=";
  };

  buildInputs = [ libpcap ];

  postPatch = ''
    substituteInPlace l2tp.h --replace /usr/sbin/pppd ${ppp}/sbin/pppd
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "http://www.xelerance.com/software/xl2tpd/";
    description = "Layer 2 Tunnelling Protocol Daemon (RFC 2661)";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
