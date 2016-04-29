{ stdenv, fetchFromGitHub, libpcap, ppp }:

let version = "1.3.6";
in stdenv.mkDerivation {
  name = "xl2tpd-${version}";

  src = fetchFromGitHub {
    owner = "xelerance";
    repo = "xl2tpd";
    rev = "v${version}";
    sha256 = "17lnsk9fsyfp2g5hha7psim6047wj9qs8x4y4w06gl6bbf36jm9z";
  };

  buildInputs = [ libpcap ];

  postPatch = ''
    substituteInPlace l2tp.h --replace /usr/sbin/pppd ${ppp}/sbin/pppd
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "http://www.xelerance.com/software/xl2tpd/";
    description = "Layer 2 Tunnelling Protocol Daemon (RFC 2661)";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
  };
}
