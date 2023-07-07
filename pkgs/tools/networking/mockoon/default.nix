{ lib
, appimageTools
, fetchurl
}:

let
  pname = "mockoon";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/mockoon/mockoon/releases/download/v${version}/mockoon-${version}.AppImage";
    hash = "sha256-YGcD/8h21fUoBEAcBVI5jo0UMCKdVRdC1zxDIrHjU+8=";
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
  };
}
