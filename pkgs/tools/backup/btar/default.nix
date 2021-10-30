{ lib, stdenv, fetchurl, fetchpatch, librsync }:

stdenv.mkDerivation rec {
  pname = "btar";
  version = "1.1.1";

  src = fetchurl {
    url = "https://vicerveza.homeunix.net/~viric/soft/btar/btar-${version}.tar.gz";
    sha256 = "0miklk4bqblpyzh1bni4x6lqn88fa8fjn15x1k1n8bxkx60nlymd";
  };

  patches = [
    (fetchpatch {
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/btar/btar-librsync.patch?rev=2";
      sha256 = "1awqny9489vsfffav19s73xxg26m7zrhvsgf1wxb8c2izazwr785";
    })
  ];

  buildInputs = [ librsync ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Tar-compatible block-based archiver";
    license = lib.licenses.gpl3Plus;
    homepage = "https://viric.name/cgi-bin/btar";
    platforms = platforms.all;
    maintainers = with maintainers; [ viric ];
  };
}
