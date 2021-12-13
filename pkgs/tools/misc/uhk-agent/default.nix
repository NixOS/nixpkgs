{ appimageTools, lib, fetchurl, makeWrapper, polkit, uhk-udev-rules }:

let
  pname = "uhk-agent";
  version = "1.5.16";
  name = "${pname}-${version}";

  src = fetchurl {
    url =
      "https://github.com/UltimateHackingKeyboard/agent/releases/download/v${version}/UHK.Agent-${version}-linux-x86_64.AppImage";
    name = "${name}.AppImage";
    sha256 = "sha256-nJxfhmHt2bnu+lQOL7zQPzBe03n6yAVtyG7Y1atOpgg=";
  };

  appimageContents = appimageTools.extract {
    name = "${pname}-${version}";
    inherit src;
  };
in appimageTools.wrapType2 {
  inherit src name;

  extraPkgs = pkgs: with pkgs; [ polkit udev uhk-udev-rules ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description =
      "Agent is the configuration application of the Ultimate Hacking Keyboard.";
    homepage = "https://github.com/UltimateHackingKeyboard/agent";
    license = licenses.mit;
    maintainers = [ poelzi ];
    platforms = [ "x86_64-linux" ];
  };
}
