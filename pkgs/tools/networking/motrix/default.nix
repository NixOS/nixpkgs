{ lib
, appimageTools
, fetchurl
}:
let
  pname = "motrix";
  version = "1.8.19";

  src = fetchurl {
    url = "https://github.com/agalwood/Motrix/releases/download/v${version}/Motrix-${version}.AppImage";
    hash = "sha256-oSO+VH3bZcjnXjECqZgOmsvlOONbfgOq50qVLvHdKfo=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A full-featured download manager";
    homepage = "https://motrix.app";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "motrix";
  };
}
