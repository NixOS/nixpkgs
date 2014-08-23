{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "winstone-${version}";
  version = "0.9.10";

  src = fetchurl {
    url = "mirror://sourceforge/winstone/${name}.jar";
    sha256 = "17xvq3yk95335c6ag1bmbmxlvh7gqq35ifi64r2l6rnvrf6pqyan";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib
    cp $src $out/lib/winstone.jar
  '';

  meta = {
    homepage = "http://winstone.sourceforge.net/";
    description = "A simple Java Servlet container.";
    license = stdenv.lib.licenses.cddl;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.rickynils ];
  };
}
