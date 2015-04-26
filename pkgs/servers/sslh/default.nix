{ stdenv, fetchurl, libcap, libconfig, perl, tcp_wrappers }:

stdenv.mkDerivation rec {
  name = "sslh-${version}";
  version = "1.17";

  src = fetchurl {
    url = "https://github.com/yrutschle/sslh/archive/v${version}.tar.gz";
    sha256 = "1l8ssm47f0hwiisgfj0ca5j2z8j98pir4pf2acrj1798fnzw6mxm";
  };

  postPatch = "patchShebangs *.sh";

  buildInputs = [ libcap libconfig perl tcp_wrappers ];

  makeFlags = "USELIBCAP=1 USELIBWRAP=1";

  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port)";
    license = licenses.gpl2Plus;
    homepage = http://www.rutschle.net/tech/sslh.shtml;
    maintainers = [ maintainers.koral ];
    platforms = platforms.all;
  };
}
