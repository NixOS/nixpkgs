{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "riemann-${version}";
  version = "0.2.9";

  src = fetchurl {
    url = "http://aphyr.com/riemann/${name}.tar.bz2";
    sha256 = "10zz92sg9ak8g7xsfc05p4kic6hzwj7nqpkjgsd8f7f3slvfjqw3";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    sed -i 's#lib/riemann.jar#$out/share/java/riemann.jar#' bin/riemann

    mkdir -p $out/share/java $out/bin $out/etc
    mv lib/riemann.jar $out/share/java/
    mv bin/riemann $out/bin/
    mv etc/riemann.config $out/etc/
  '';

  meta = with stdenv.lib; {
    homepage = http://riemann.io/;
    description = "A network monitoring system";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = [ maintainers.rickynils ];
  };
}
