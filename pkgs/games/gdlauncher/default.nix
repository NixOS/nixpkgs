{ appimageTools, fetchurl, lib }:
appimageTools.wrapType2 rec {
  pname = "gdlauncher";
  version = "1.1.30";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/gorilla-devs/GDLauncher/releases/download/v${version}/GDLauncher-linux-setup.AppImage";
    hash = "sha256-4cXT3exhoMAK6gW3Cpx1L7cm9Xm0FK912gGcRyLYPwM=";
  };

  appimageContents = appimageTools.extractType2 { inherit name src; };

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -Dm444 ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A simple, yet powerful Minecraft custom launcher with a strong focus on the user experience";
    homepage = "https://gdlauncher.com/";
    changelog = "https://github.com/gorilla-devs/GDLauncher/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ PassiveLemon ];
    platforms = [ "x86_64-linux" ];
  };
}
