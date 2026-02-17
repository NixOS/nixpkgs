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

      meta = {
        changelog = "https://github.com/jetty/jetty.project/releases/tag/jetty-${version}";
        description = "Web server and javax.servlet container";
        homepage = "https://jetty.org/";
        platforms = lib.platforms.all;
        sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
        license = with lib.licenses; [
          asl20
          epl10
        ];
        maintainers = with lib.maintainers; [
          emmanuelrosa
          anthonyroussel
        ];
      };
    };

in
{
  jetty_11 = common {
    version = "11.0.26";
    hash = "sha256-uJgh/+/uGjchTgtoF38f7jIvbdrwdToAsqqVOlYtMIM=";
  };

  jetty_12 = common {
    version = "12.1.6";
    hash = "sha256-a23PR+6Qy32/evrEO7Nur8Y8KQnrfVyTV/qFi4ttG+Q=";
  };
}
