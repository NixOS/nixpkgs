{ stdenv, fetchurl, fetchpatch, libjpeg }:

stdenv.mkDerivation rec {
  pname = "jhead";
  version = "3.04";

  src = fetchurl {
    url = "http://www.sentex.net/~mwandel/jhead/${pname}-${version}.tar.gz";
    sha256 = "1j831bqw1qpkbchdriwcy3sgzvbagaj45wlc124fs9bc9z7vp2gg";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/j/jhead/1:3.04-2/debian/patches/01_gpsinfo.c";
      sha256 = "0r8hdbfrdxip4dwz5wqsv47a29j33cx7w5zx4jdhp5l1ihg003lz";
    })
  ];

  buildInputs = [ libjpeg ];

  makeFlags = [ "CPPFLAGS=" "CFLAGS=-O3" "LDFLAGS=" ];

  patchPhase = ''
    sed -i '/dpkg-buildflags/d' makefile
    substituteInPlace jhead.c \
      --replace "jpegtran -trim" "${libjpeg.bin}/bin/jpegtran -trim"
  '';

  installPhase = ''
    mkdir -p \
      $out/bin \
      $out/man/man1 \
      $out/share/doc/${pname}-${version}

    cp -v jhead $out/bin
    cp -v jhead.1 $out/man/man1
    cp -v *.txt $out/share/doc/${pname}-${version}
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.sentex.net/~mwandel/jhead/";
    description = "Exif Jpeg header manipulation tool";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
