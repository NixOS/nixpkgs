{ copyDesktopItems, fetchurl, jre, lib, makeDesktopItem, makeWrapper, stdenv, steam-run, withSteamRun ? true, writeShellScript }:

stdenv.mkDerivation (finalAttrs: {
  pname = "atlauncher";
  version = "3.4.28.1";

  src = fetchurl {
    url = "https://github.com/ATLauncher/ATLauncher/releases/download/v${finalAttrs.version}/ATLauncher-${finalAttrs.version}.jar";
    hash = "sha256-IIwDMazxUMQ7nGQk/4VEZicgCmCR4oR8UYtO36pCEq4=";
  };

  dontUnpack = true;

  buildInputs = [ ];
  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  installPhase =
    let
      # hack to use steam-run along with the exec
      steamrun = writeShellScript "steamrun" ''
        shift
        exec ${steam-run}/bin/steam-run "''$@"
      '';
    in
    ''
      runHook preInstall
      mkdir -p $out/bin
      makeWrapper ${jre}/bin/java $out/bin/atlauncher \
        --add-flags "-jar $src --working-dir=\$HOME/.atlauncher" \
        --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" ${
            lib.strings.optionalString withSteamRun ''--run "${steamrun} \\"''
          }
      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = finalAttrs.pname;
      icon = fetchurl {
        url = "https://avatars.githubusercontent.com/u/7068667";
        hash = "sha256-YmEkxf4rZxN3jhiib0UtdUDDcn9lw7IMbiEucBL7b9o=";
      };
      desktopName = "ATLauncher";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "A simple and easy to use Minecraft launcher which contains many different modpacks for you to choose from and play";
    downloadPage = "https://atlauncher.com/downloads";
    homepage = "https://atlauncher.com/";
    license = licenses.gpl3;
    maintainers = [ maintainers.getpsyched ];
    platforms = platforms.all;
  };
})
