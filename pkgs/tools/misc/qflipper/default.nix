{ lib, fetchurl, appimageTools }:

let
  pname = "qflipper";
  version = "0.5.3";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://update.flipperzero.one/builds/qFlipper/${version}/qFlipper-x86_64-${version}.AppImage";
    sha256 = "sha256-UFGFl1zb0t1y7FBd5EX1YS3npWM5slL/wLiTOF/CLNM=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };

in appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/qFlipper
    install -m 444 -D ${appimageContents}/qFlipper.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Cross-platform desktop tool to manage your flipper device";
    homepage = "https://flipperzero.one/";
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
