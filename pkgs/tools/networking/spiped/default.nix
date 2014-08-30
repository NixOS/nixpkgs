{ stdenv, fetchurl, openssl, coreutils }:

stdenv.mkDerivation rec {
  name    = "spiped-${version}";
  version = "1.4.0";

  src = fetchurl {
    url    = "http://www.tarsnap.com/spiped/${name}.tgz";
    sha256 = "0pyg1llnqgfx7n7mi3dq4ra9xg3vkxlf01z5jzn7ncq5d6ii7ynq";
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
