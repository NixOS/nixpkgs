{ lib, appimageTools, makeWrapper, fetchurl }:

let
  pname = "altair";
  version = "5.2.6";

  src = fetchurl {
    url = "https://github.com/imolorhe/altair/releases/download/v${version}/altair_${version}_x86_64_linux.AppImage";
    sha256 = "sha256-SNXUARAu4szX7otyAKy3F/piNhxlPVNN6Dj2UwevL8A=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit src pname version;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

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
