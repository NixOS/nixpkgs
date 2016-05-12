{ stdenv, fetchurl, libcap, libconfig, perl, tcp_wrappers }:

stdenv.mkDerivation rec {
  name = "sslh-${version}";
  version = "1.18";

  src = fetchurl {
    url = "http://www.rutschle.net/tech/sslh/sslh-v${version}.tar.gz";
    sha256 = "1ba5fxd2s6jh9n3wbp2a782q7syc4m6qvfrggnscdbywfyrsa08n";
  };

  postPatch = "patchShebangs *.sh";

  buildInputs = [ libcap libconfig perl tcp_wrappers ];

  makeFlags = "USELIBCAP=1 USELIBWRAP=1";

  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port)";
    license = licenses.gpl2Plus;
    homepage = http://www.rutschle.net/tech/sslh.shtml;
    maintainers = with maintainers; [ koral fpletz ];
    platforms = platforms.all;
  };
}
