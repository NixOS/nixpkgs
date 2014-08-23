{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "g500-control-0.0.1";

  src = fetchurl {
    url = "http://g500-control.googlecode.com/files/g500_control_0.0.1.tar.gz";
    sha256 = "1xlg9lpxnk3228k81y1i6jjh4df1p4jh64g54w969g6a6v6dazvb";
  };

  unpackPhase = ''
    mkdir -p g500-control
    tar -C g500-control/ -xf $src
  '';

  buildPhase = ''
    cd g500-control
    gcc -o g500-control *.c
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp g500-control $out/bin/
  '';

  meta = {
    homepage = http://code.google.com/p/g500-control/;
    description = "Configure Logitech G500's internal profile under Linux";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}

