{ stdenv, fetchurl, libcap, libconfig, perl, tcp_wrappers, pcre, nixosTests }:

stdenv.mkDerivation rec {
  pname = "sslh";
  version = "1.21";

  src = fetchurl {
    url = "https://www.rutschle.net/tech/sslh/sslh-v${version}.tar.gz";
    sha256 = "1am63nslvv9xkbn9xavpf1zl6f7g1snz8cvnzlya7dq4la4y97d7";
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
