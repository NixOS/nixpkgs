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

<<<<<<< HEAD
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
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    version = "12.1.5";
    hash = "sha256-tjZO7OtQ7FZQAGA9lI4YIKwm+ZW0eJgGTaNd+ZasDY4=";
=======
    version = "12.1.4";
    hash = "sha256-no5Ge4pdYKN+tXUJq10RKCTtRLFNdz5sOuw6o+ZxXdY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
