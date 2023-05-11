{ lib, fetchurl, appimageTools, version, url, sha512, pname, internalName }:

let
  name = "${pname}-${version}";

  src = fetchurl {
    inherit sha512 url;
    name = "${internalName}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 {
  inherit name src;

  multiPkgs = null; # no 32bit needed
  extraPkgs = pkgs: appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ [ pkgs.bash ];

  extraInstallCommands = ''
    ln -s $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${internalName}.desktop \
      $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${internalName}.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Modern and easy to use SQL client for MySQL, Postgres, SQLite, SQL Server, and more. Linux, MacOS, and Windows";
    homepage = "https://www.beekeeperstudio.io";
    changelog = "https://github.com/beekeeper-studio/beekeeper-studio/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ milogert alexnortung ];
    platforms = platforms.linux;
  };
}
