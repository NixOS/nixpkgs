{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.3.5";
  name = "rhash-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/rhash/${name}-src.tar.gz";
    sha256 = "0bhz3xdl6r06k1bqigdjz42l31iqz2qdpg7zk316i7p2ra56iq4q";
  };

  patches = stdenv.lib.optional stdenv.isDarwin ./darwin.patch;

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=/" "AR:=$(AR)" "CC:=$(CC)" ];

  buildFlags = [ "build-shared" "lib-shared" ];

  installPhase = ''
    make $makeFlags -C librhash install-lib-shared install-headers install-so-link
    make $makeFlags install-shared
  '';

  meta = with stdenv.lib; {
    homepage = http://rhash.anz.ru;
    description = "Console utility and library for computing and verifying hash sums of files";
    platforms = platforms.all;
    maintainers = [ maintainers.andrewrk ];
  };
}
