{ lib, fetchurl, appimageTools }:
let
  pname = "flight-core";
  version = "2.14.9";
  name = "${pname}_${version}";
  src = fetchurl {
    url = "https://github.com/R2NorthstarTools/FlightCore/releases/download/v${version}/${name}_amd64.AppImage";
    hash = "sha256-DoVvX8ayxUeDq9GpFXccVDEuq7DvblvPPyhLCzDqz1M=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;
  extraPkgs = pkgs: with pkgs; [ libthai pango ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/flight-core.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Installer/Updater/Launcher for Northstar";
    homepage = "https://github.com/R2NorthstarTools/FlightCore";
    license = licenses.mit;
    maintainers = with maintainers; [ yamamech ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "flight-core";
  };
}
