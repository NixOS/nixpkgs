{ stdenv, fetchurl, libcap, libconfig, perl, tcp_wrappers, pcre }:

stdenv.mkDerivation rec {
  name = "sslh-${version}";
  version = "1.19c";

  src = fetchurl {
    url = "http://www.rutschle.net/tech/sslh/sslh-v${version}.tar.gz";
    sha256 = "1wvvqj9r293skgqi28q4ixz7zwf301h1bf514p41xbi7ifldy4dv";
  };

  postPatch = "patchShebangs *.sh";

  buildInputs = [ libcap libconfig perl tcp_wrappers pcre ];

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
