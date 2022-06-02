{ lib, stdenv, fetchurl, makeWrapper, jdk, selenium-server-standalone }:

with lib;
let
    pname = "selendroid-standalone";
    pluginName = "selendroid-grid-plugin-${version}";
    version = "0.17.0";
    srcs = {
      jar = fetchurl {
        url = "https://github.com/selendroid/selendroid/releases/download/${version}/selendroid-standalone-${version}-with-dependencies.jar";
        sha256 = "10lxdsgp711pv8r6dk2aagnbvnn1b25zfqjvz7plc73zqhx1dxvw";
      };
      gridPlugin = fetchurl {
        url = "https://search.maven.org/remotecontent?filepath=io/selendroid/selendroid-grid-plugin/${version}/${pluginName}.jar";
        sha256 = "1x6cjmp2hpghbgbf8vss0qaj2n4sfl29wp3bc4k1s3hnnpccvz70";
      };
    };
in
stdenv.mkDerivation {
  inherit pname version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk ];

  installPhase = ''
    mkdir -p $out/share/lib/selendroid
    cp ${srcs.jar} $out/share/lib/selendroid/selendroid-standalone-${version}.jar
    cp ${srcs.gridPlugin} $out/share/lib/selendroid/${pluginName}.jar

    makeWrapper ${jdk}/bin/java $out/bin/selendroid \
      --add-flags "-jar $out/share/lib/selendroid/selendroid-standalone-${version}.jar"
    makeWrapper ${jdk}/bin/java $out/bin/selendroid-selenium \
      --add-flags "-Dfile.encoding=UTF-8" \
      --add-flags "-cp ${selenium-server-standalone}/share/lib/${selenium-server-standalone.name}/${selenium-server-standalone.name}.jar:$out/share/lib/selendroid/${pluginName}.jar" \
      --add-flags "org.openqa.grid.selenium.GridLauncherV3" \
      --add-flags "-role hub" \
      --add-flags "-capabilityMatcher io.selendroid.grid.SelendroidCapabilityMatcher"
  '';

  meta = {
    homepage = "http://selendroid.io/";
    description = "Test automation for native or hybrid Android apps and the mobile web";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.all;
    license = licenses.asl20;
  };
}
