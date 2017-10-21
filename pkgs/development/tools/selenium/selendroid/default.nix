{ stdenv, fetchurl, makeWrapper, jdk, selenium-server-standalone }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "selendroid-standalone-${version}";
  version = "0.11.0";

  src = fetchurl {
    url = "https://github.com/selendroid/selendroid/releases/download/${version}/selendroid-standalone-${version}-with-dependencies.jar";
    sha256 = "1p6k974pr2634q1g65wx243cxdqhac63x8w2gsmh6vnni0818clk";
  };

  unpackPhase = "true";

  buildInputs = [ jdk makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/lib/selendroid
    cp $src $out/share/lib/selendroid/${name}.jar
    makeWrapper ${jdk}/bin/java $out/bin/selendroid \
      --add-flags "-jar $out/share/lib/selendroid/${name}.jar"
    makeWrapper ${jdk}/bin/java $out/bin/selendroid-selenium \
      --add-flags "-Dfile.encoding=UTF-8" \
      --add-flags "-cp \"$out/share/lib/selendroid/${name}.jar:${selenium-server-standalone}/share/lib/${selenium-server-standalone.name}/${selenium-server-standalone.name}.jar\"" \
      --add-flags "org.openqa.grid.selenium.GridLauncherV3"
  '';

  meta = {
    homepage = https://code.google.com/p/selenium;
    description = "Test automation for native or hybrid Android apps and the mobile web";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.all;
    license = licenses.asl20;
  };
}
