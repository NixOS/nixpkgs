{ stdenv, fetchurl, openssl, coreutils }:

stdenv.mkDerivation rec {
  name    = "spiped-${version}";
  version = "1.3.1";

  src = fetchurl {
    url    = "http://www.tarsnap.com/spiped/${name}.tgz";
    sha256 = "1viglk61v1v2ga1n31r0h8rvib5gy2h02lhhbbnqh2s6ps1sjn4a";
  };

  buildInputs = [ openssl ];
  patches = [ ./no-dev-stderr.patch ];

  postPatch = ''
    substituteInPlace POSIX/posix-l.sh --replace "rm" "${coreutils}/bin/rm"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    make install BINDIR=$out/bin MAN1DIR=$out/share/man/man1
  '';

  meta = {
    description = "utility for secure encrypted channels between sockets";
    homepage    = "https://www.tarsnap.com/spiped.html";
    license     = stdenv.lib.licenses.bsd2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
