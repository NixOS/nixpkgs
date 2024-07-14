{ version, hash }:

{ lib, stdenvNoCC, fetchurl, gitUpdater }:

stdenvNoCC.mkDerivation rec {
  pname = "jetty";

  inherit version;

  src = fetchurl {
    url = "mirror://maven/org/eclipse/jetty/jetty-home/${version}/jetty-home-${version}.tar.gz";
    inherit hash;
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    mv etc lib modules start.jar $out
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/jetty/jetty.project.git";
    allowedVersions = "^${lib.versions.major version}\\.";
    ignoredVersions = "(alpha|beta).*";
    rev-prefix = "jetty-";
  };

  meta = with lib; {
    description = "Web server and javax.servlet container";
    homepage = "https://eclipse.dev/jetty/";
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = with licenses; [ asl20 epl10 ];
    maintainers = with maintainers; [ emmanuelrosa anthonyroussel ];
  };
}
