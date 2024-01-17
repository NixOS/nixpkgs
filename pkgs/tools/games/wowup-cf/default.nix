{ lib, appimageTools, fetchurl }:

let
  version = "2.10.0";
  pname = "wowup-cf";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/WowUp/WowUp.CF/releases/download/v${version}/WowUp-CF-${version}.AppImage";
    hash = "sha256-u8rziod2RVSCaqSBgShqFeVrRo9MvHr7cCujSAYpULM=";
  };

  appimageContents = appimageTools.extractType1 { inherit name src; };
in appimageTools.wrapType1 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "World of Warcraft addon updater with CurseForge support";
    longDescription = ''
    WowUp is the community centered World of Warcraft addon updater. We attempt to bring the addon community together in an easy to use updater application. We have an ever growing list of supported features.
    '';
    homepage = "https://wowup.io/";
    downloadPage = "https://wowup.io/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ enoz ];
    platforms = [ "x86_64-linux" ];
  };
}

