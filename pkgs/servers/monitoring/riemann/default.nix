{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "riemann-${version}";
  version = "0.2.8";

  src = fetchurl {
    url = "http://aphyr.com/riemann/${name}.tar.bz2";
    sha256 = "1p2pdkxy2xc5zlj6kadf4z8l0f0r4bvdgipqf52193l7rdm6dfzm";
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
