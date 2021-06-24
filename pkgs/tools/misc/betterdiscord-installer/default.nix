{ appimageTools, lib, fetchurl }:
let
  pname = "betterdiscord-installer";
  version = "1.0.0-beta";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/BetterDiscord/Installer/releases/download/v${version}/Betterdiscord-Linux.AppImage";
    sha256 = "103acb11qmvjmf6g9lgsfm5jyahfwfdqw0x9w6lmv1hzwbs26dsr";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/betterdiscord.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/betterdiscord.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Installer for BetterDiscord";
    homepage = "https://betterdiscord.net";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
  };
}
