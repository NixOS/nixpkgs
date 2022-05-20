{ appimageTools, lib, fetchurl, polkit, udev }:
let
  pname = "uhk-agent";
  version = "1.5.17";
  src = fetchurl {
    url = "https://github.com/UltimateHackingKeyboard/agent/releases/download/v${version}/UHK.Agent-${version}-linux-x86_64.AppImage";
    name = "${pname}-${version}.AppImage";
    sha256 = "sha256-auOoTTRmkXVDDvcmRFzQIStNlbai8bTBLb/KUjk6EAc=";
  };

  appimageContents = appimageTools.extract {
    name = "${pname}-${version}";
    inherit src;
  };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [ polkit udev ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    install -m 644 -D ${appimageContents}/resources/rules/50-uhk60.rules $out/rules/50-uhk60.rules
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';
  # wrapType2 does not passthru pname+version
  passthru.version = version;

  meta = with lib; {
    description = "Agent is the configuration application of the Ultimate Hacking Keyboard";
    homepage = "https://github.com/UltimateHackingKeyboard/agent";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ ngiger ];
    platforms = [ "x86_64-linux" ];
  };
}
