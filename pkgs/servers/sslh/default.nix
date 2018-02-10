{ stdenv, fetchurl, libcap, libconfig, perl, tcp_wrappers, pcre }:

stdenv.mkDerivation rec {
  name = "sslh-${version}";
  version = "1.19";

  src = fetchurl {
    url = "http://www.rutschle.net/tech/sslh/sslh-v${version}.tar.gz";
    sha256 = "17362d3srrr49c3vvyg69maynpxac92wvi5j0nvlnh6sjs1v377g";
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
