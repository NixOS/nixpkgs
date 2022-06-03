{ lib, fetchurl, appimageTools }:

let
  pname = "insomnia";
  version = "2022.3.0";
  src = fetchurl {
    url = "https://github.com/Kong/insomnia/releases/download/core%40${version}/Insomnia.Core-${version}.AppImage";
    sha256 = "sha256-cPdRxb9Nqu+CQ6Ebcp4M7snI0oo8lrYEgQFLQhET9yk=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/insomnia.desktop -t $out/share/applications

    substituteInPlace $out/share/applications/insomnia.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/insomnia.png \
      $out/share/icons/hicolor/512x512/apps/insomnia.png
  '';

  meta = with lib; {
    homepage = "https://insomnia.rest/";
    description = "The most intuitive cross-platform REST API Client";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ markus1189 babariviere khushraj ];
  };
}
