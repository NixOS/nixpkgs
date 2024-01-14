{ appimageTools, lib, fetchurl }:
let
  pname = "betterdiscord-installer";
  version = "1.3.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/BetterDiscord/Installer/releases/download/v${version}/Betterdiscord-Linux.AppImage";
    sha256 = "sha256-In5J6TWoJsFODDwMXd1lMg3341IZJD2OJebVtgISxP0=";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/betterdiscord-installer.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/betterdiscord-installer.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Installer for BetterDiscord";
    homepage = "https://betterdiscord.app";
    license = licenses.mit;
    maintainers = with maintainers; [ ivar aikooo7 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "betterdiscord-installer";
  };
}
