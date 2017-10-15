{ stdenv, fetchurl, makeWrapper, jdk, selenium-server-standalone }:

with stdenv.lib;
let
    name = "selendroid-standalone-${version}";
    pluginName = "selendroid-grid-plugin-${version}";
    version = "0.11.0";
    srcs = {
      jar = fetchurl {
        url = "https://github.com/selendroid/selendroid/releases/download/${version}/${name}-with-dependencies.jar";
        sha256 = "1p6k974pr2634q1g65wx243cxdqhac63x8w2gsmh6vnni0818clk";
      };
      gridPlugin = fetchurl {
        url = "https://search.maven.org/remotecontent?filepath=io/selendroid/selendroid-grid-plugin/${version}/${pluginName}.jar";
        sha256 = "1iazmdv2z0k03fa1xlfipwdf3s9j6404kkpfs5xdyy0513ah02a0";
      };
    };
in
stdenv.mkDerivation rec {

  inherit name;
  inherit version;

  unpackPhase = "true";

  buildInputs = [ jdk makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/lib/selendroid
    cp ${srcs.jar} $out/share/lib/selendroid/${name}.jar
    cp ${srcs.gridPlugin} $out/share/lib/selendroid/${pluginName}.jar

    makeWrapper ${jdk}/bin/java $out/bin/selendroid \
      --add-flags "-jar $out/share/lib/selendroid/${name}.jar"
    makeWrapper ${jdk}/bin/java $out/bin/selendroid-selenium \
      --add-flags "-Dfile.encoding=UTF-8" \
      --add-flags "-cp ${selenium-server-standalone}/share/lib/${selenium-server-standalone.name}/${selenium-server-standalone.name}.jar:$out/share/lib/selendroid/${pluginName}.jar" \
      --add-flags "org.openqa.grid.selenium.GridLauncherV3" \
      --add-flags "-role hub" \
      --add-flags "-capabilityMatcher io.selendroid.grid.SelendroidCapabilityMatcher"
  '';

  meta = {
    homepage = http://selendroid.io/;
    description = "Test automation for native or hybrid Android apps and the mobile web";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.all;
    license = licenses.asl20;
  };
}
