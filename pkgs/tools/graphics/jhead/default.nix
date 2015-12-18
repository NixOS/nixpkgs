{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jhead-${version}";
  version = "3.00";

  src = fetchurl {
    url = "http://www.sentex.net/~mwandel/jhead/${name}.tar.gz";
    sha256 = "0pl9s9ssb2a9di82f3ypin2hd098ns8kzdsxw3i2y94f07d03k48";
  };

  patchPhase = ''
    substituteInPlace makefile \
      --replace /usr/local/bin $out/bin

    substituteInPlace jhead.c \
      --replace "\"   Compiled: \"__DATE__" ""
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
    maintainers = with maintainers; [ viric rycee ];
    platforms = platforms.all;
  };
}
