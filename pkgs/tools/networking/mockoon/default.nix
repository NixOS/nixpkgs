{ lib
, appimageTools
, fetchurl
, nix-update-script
}:

let
  pname = "mockoon";
  version = "8.1.1";

  src = fetchurl {
    url = "https://github.com/mockoon/mockoon/releases/download/v${version}/mockoon-${version}.x86_64.AppImage";
    hash = "sha256-USL/arTewBOe6xiN5iIB5eayU62xHY47y5OS8YWtIUs=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "The easiest and quickest way to run mock APIs locally";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    homepage = "https://mockoon.com";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "mockoon";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
  };
}
