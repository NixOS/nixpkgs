{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "riemann-${version}";
  version = "0.2.6";

  src = fetchurl {
    url = "http://aphyr.com/riemann/${name}.tar.bz2";
    sha256 = "1m1vkvdcpcc93ipzpdlq0lig81yw172qfiqbxlrbjyb0x6j1984d";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/java
    mv lib/riemann.jar $out/share/java/
  '';

  meta = with stdenv.lib; {
    homepage = http://riemann.io/;
    description = "A network monitoring system";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = [ maintainers.rickynils ];
  };
}
