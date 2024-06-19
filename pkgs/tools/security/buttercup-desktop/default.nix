{ lib, fetchurl, appimageTools }:

let
  pname = "buttercup-desktop";
  version = "2.27.0";
  src = fetchurl {
    url = "https://github.com/buttercup/buttercup-desktop/releases/download/v${version}/Buttercup-linux-x86_64.AppImage";
    sha256 = "sha256-zpb5c3qGfBoRX9V1lVRX8607hBEHgjR8ZWJizfYNgUM=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };

in appimageTools.wrapType2 {
  inherit pname src version;

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/buttercup.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/buttercup.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Cross-Platform Passwords & Secrets Vault";
    mainProgram = "buttercup-desktop";
    homepage = "https://buttercup.pw";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
