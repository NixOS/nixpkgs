{ lib, appimageTools, fetchurl }:

let
  pname = "altair";
  version = "4.6.2";

  src = fetchurl {
    url = "https://github.com/imolorhe/altair/releases/download/v${version}/altair_${version}_x86_64_linux.AppImage";
    sha256 = "sha256-D2Ivem7xg4KrAHYxs4Cx7Ekgyc5u2KrjX4miYz11wuI=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit src pname version;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A feature-rich GraphQL Client IDE";
    homepage = "https://github.com/imolorhe/altair";
    license = licenses.mit;
    maintainers = with maintainers; [ evalexpr ];
    platforms = [ "x86_64-linux" ];
  };
}
