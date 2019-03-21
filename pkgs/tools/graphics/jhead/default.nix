{ stdenv, fetchurl, libjpeg }:

stdenv.mkDerivation rec {
  name = "jhead-${version}";
  version = "3.03";

  src = fetchurl {
    url = "http://www.sentex.net/~mwandel/jhead/${name}.tar.gz";
    sha256 = "1hn0yqcicq3qa20h1g313l1a671r8mccpb9gz0w1056r500lw6c2";
  };

  buildInputs = [ libjpeg ];

  patchPhase = ''
    substituteInPlace makefile \
      --replace /usr/local/bin $out/bin

    substituteInPlace jhead.c \
      --replace "\"   Compiled: \"__DATE__" "" \
      --replace "jpegtran -trim" "${libjpeg.bin}/bin/jpegtran -trim"
  '';

  installPhase = ''
    mkdir -p \
      $out/bin \
      $out/man/man1 \
      $out/share/doc/${name}

    cp -v jhead $out/bin
    cp -v jhead.1 $out/man/man1
    cp -v *.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = http://www.sentex.net/~mwandel/jhead/;
    description = "Exif Jpeg header manipulation tool";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ rycee ];
    platforms = platforms.all;
  };
}
