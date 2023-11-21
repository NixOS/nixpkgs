{ lib, appimageTools, fetchurl, makeDesktopItem }:

appimageTools.wrapType2 rec {
  pname = "gb-studio";
  version = "3.1.0";

  src = fetchurl {
    url =
      "https://github.com/chrismaltby/${pname}/releases/download/v${version}/${pname}-linux.AppImage";
    hash = "sha256-vHk7rDbQsU+qPSdhH/34OTvS4jG5ybyPEr9ZTl4ZUxs=";
  };

  runScript = "appimage-exec.sh -w ${
      appimageTools.extractType2 { inherit pname version src; }
    } -- --disable-seccomp-filter-sandbox";

  extraInstallCommands = let
    desktopItem = makeDesktopItem {
      name = pname;
      desktopName = "GB Studio";
      comment = "Visual retro game maker";
      genericName = "GB Studio";
      exec = "${meta.mainProgram} %U";
      icon = pname;
      type = "Application";
      startupNotify = true;
      categories = [ "GNOME" "GTK" "Utility" ];
    };
    # bash
  in ''
    mv "$out/bin/${pname}-${version}" "$out/bin/${pname}"
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications
  '';

  meta = with lib; {
    description =
      "A quick and easy to use drag and drop retro game creator for your favourite handheld video game system";
    homepage = "https://www.gbstudio.dev/";
    changelog =
      "https://github.com/chrismaltby/${pname}/releases/tag/v${version}";
    mainProgram = pname;
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ musjj ];
  };
}
