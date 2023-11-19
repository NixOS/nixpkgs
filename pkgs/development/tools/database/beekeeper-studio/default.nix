{ lib, fetchurl, appimageTools, pkgs, makeWrapper }:

let
  pname = "beekeeper-studio";
  version = "3.6.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/Beekeeper-Studio-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    hash = "sha512-an4Gqx2mx/rnkLe/LUAz3qRdrqWBcrWcdCiNi8Hz1OKBp1SWN3acU8RppIM0uwlrcBkjnigbbM5DZ2o+svA23A==";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 {
  inherit name src;

  multiArch = false; # no 32bit needed
  extraPkgs = pkgs: appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ [ pkgs.bash ];

  extraInstallCommands = ''
    ln -s $out/bin/${name} $out/bin/${pname}
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png \
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
    platforms = [ "x86_64-linux" ];
  };
}
