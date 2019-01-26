{ stdenv, fetchurl, libcap, libconfig, perl, tcp_wrappers, pcre }:

stdenv.mkDerivation rec {
  name = "sslh-${version}";
  version = "1.20";

  src = fetchurl {
    url = "https://www.rutschle.net/tech/sslh/sslh-v${version}.tar.gz";
    sha256 = "05jihpjxx094h7hqzgd9v5jmy77ipwrakzzmjyfvpdzw3h59px57";
  };

  postPatch = "patchShebangs *.sh";

  buildInputs = [ libcap libconfig perl tcp_wrappers pcre ];

  makeFlags = [ "USELIBCAP=1" "USELIBWRAP=1" ];

  installFlags = [ "PREFIX=$(out)" ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port)";
    license = licenses.gpl2Plus;
    homepage = https://www.rutschle.net/tech/sslh/README.html;
    maintainers = with maintainers; [ koral fpletz ];
    platforms = platforms.all;
  };
}
