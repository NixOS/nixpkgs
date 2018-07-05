{ wrapCommand, fetchurl, lib, makeWrapper, jre }:

let
  version = "1.1.0";
  jar = fetchurl {
    url = "https://github.com/scobal/seyren/releases/download/${version}/seyren-${version}.jar";
    sha256 = "10m64zdci4swlvivii1jnmrwfi461af3xvn0xvwvy7i8kyb56vrr";
  };

in wrapCommand "seyren" {
  inherit version;
  executable = "${jre}/bin/java";
  makeWrapperArgs = [ "--add-flags -jar" "--add-flags ${jar}" ];
  meta = with lib; {
    description = "An alerting dashboard for Graphite";
    homepage = https://github.com/scobal/seyren;
    license = licenses.asl20;
    maintainers = [ maintainers.offline ];
    platforms = platforms.all;
  };
}
