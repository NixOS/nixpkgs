{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "riemann-${version}";
  version = "0.2.7";

  src = fetchurl {
    url = "http://aphyr.com/riemann/${name}.tar.bz2";
    sha256 = "1hnjikm24jlfi5qav7gam078k5gynca36xbxr3b3lbhw17kyknwg";
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
