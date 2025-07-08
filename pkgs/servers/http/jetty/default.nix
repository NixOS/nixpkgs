{
  lib,
  stdenvNoCC,
  fetchurl,
  gitUpdater,
}:

let
  common =
    { version, hash }:
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
        changelog = "https://github.com/jetty/jetty.project/releases/tag/jetty-${version}";
        description = "Web server and javax.servlet container";
        homepage = "https://jetty.org/";
        platforms = platforms.all;
        sourceProvenance = with sourceTypes; [ binaryBytecode ];
        license = with licenses; [
          asl20
          epl10
        ];
        maintainers = with maintainers; [
          emmanuelrosa
          anthonyroussel
        ];
      };
    };

in
{
  jetty_11 = common {
    version = "11.0.25";
    hash = "sha256-KaceKN/iu0QCv9hVmoXYvN7TxK9DwhiCcbjEnqcKSzs=";
  };

  jetty_12 = common {
    version = "12.0.23";
    hash = "sha256-oY6IU59ir52eM4qO2arOLErN4CEUCT0iRM4I9ip+m3I=";
  };
}
