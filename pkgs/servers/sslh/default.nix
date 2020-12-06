{ stdenv, fetchurl, libcap, libconfig, perl, tcp_wrappers, pcre, nixosTests }:

stdenv.mkDerivation rec {
  pname = "sslh";
  version = "1.21c";

  src = fetchurl {
    url = "https://www.rutschle.net/tech/sslh/sslh-v${version}.tar.gz";
    sha256 = "01p7w74ppszxgz6n41lqd6xqvc7bjk2dsc769dd1yb7q4qvpiziv";
  };

  postPatch = "patchShebangs *.sh";

  buildInputs = [ libcap libconfig perl tcp_wrappers pcre ];

  makeFlags = [ "USELIBCAP=1" "USELIBWRAP=1" ];

  installFlags = [ "PREFIX=$(out)" ];

  hardeningDisable = [ "format" ];

  passthru.tests = {
    inherit (nixosTests) sslh;
  };

  meta = with stdenv.lib; {
    description = "Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port)";
    license = licenses.gpl2Plus;
    homepage = "https://www.rutschle.net/tech/sslh/README.html";
    maintainers = with maintainers; [ koral fpletz ];
    platforms = platforms.all;
  };
}
