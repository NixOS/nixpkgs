{ stdenv, fetchFromGitHub, libpcap, ppp }:

stdenv.mkDerivation rec {
  pname = "xl2tpd";
  version = "1.3.15";

  src = fetchFromGitHub {
    owner = "xelerance";
    repo = "xl2tpd";
    rev = "v${version}";
    sha256 = "0ppwza8nwm1av1vldw40gin9wrjrs4l9si50jad414js3k8ycaag";
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
