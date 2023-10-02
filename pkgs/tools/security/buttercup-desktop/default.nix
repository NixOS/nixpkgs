{ lib, fetchurl, appimageTools }:

let
  pname = "buttercup-desktop";
  version = "2.20.3";
  src = fetchurl {
    url = "https://github.com/buttercup/buttercup-desktop/releases/download/v${version}/Buttercup-linux-x86_64.AppImage";
    sha256 = "sha256-e7CZjJSkAAkNn73Z3cg+D5SUdReBp6pqz7zKrbkHs38=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };

in appimageTools.wrapType2 {
  inherit pname src version;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/buttercup.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/buttercup.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Cross-Platform Passwords & Secrets Vault";
    homepage = "https://buttercup.pw";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
