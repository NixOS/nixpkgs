{ appimageTools, lib, fetchurl }:
let
  pname = "betterdiscord-installer";
  version = "1.1.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/BetterDiscord/Installer/releases/download/v${version}/Betterdiscord-Linux.AppImage";
    sha256 = "1198fcbd1c966c47c26a0cbfc774131400ef13a67be9faa70d54506610f44b69";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 {
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
    maintainers = [ maintainers.ivar maintainers["3nt3"] ];
    platforms = [ "x86_64-linux" ];
  };
}
