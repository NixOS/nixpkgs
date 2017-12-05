{ stdenv, fetchFromGitHub, libpcap, ppp }:

stdenv.mkDerivation rec {
  name = "xl2tpd-${version}";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "xelerance";
    repo = "xl2tpd";
    rev = "v${version}";
    sha256 = "0wjkj2b5rkxhx522wmkml5s0zdp68hkvrh7npx839dvsr79fji7k";
  };

  buildInputs = [ libpcap ];

  postPatch = ''
    substituteInPlace l2tp.h --replace /usr/sbin/pppd ${ppp}/sbin/pppd
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://www.xelerance.com/software/xl2tpd/;
    description = "Layer 2 Tunnelling Protocol Daemon (RFC 2661)";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
