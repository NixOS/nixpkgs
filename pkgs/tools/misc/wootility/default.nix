{ appimageTools
, fetchurl
, lib
, xorg
, udev
, wooting-udev-rules
, makeWrapper
}:

appimageTools.wrapType2 rec {
  pname = "wootility";
  version = "4.6.20";

  src = fetchurl {
    url = "https://s3.eu-west-2.amazonaws.com/wooting-update/wootility-lekker-linux-latest/wootility-lekker-${version}.AppImage";
    sha256 = "sha256-JodmF3TThPpXXx1eOnYmYAJ4x5Ylcf35bw3R++5/Buk=";
  };

  extraInstallCommands =
    let contents = appimageTools.extract { inherit pname version src; };
    in ''
      source "${makeWrapper}/nix-support/setup-hook"
      wrapProgram $out/bin/wootility \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

      install -Dm444 ${contents}/wootility-lekker.desktop -t $out/share/applications
      install -Dm444 ${contents}/wootility-lekker.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/wootility-lekker.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=wootility' \
        --replace-warn 'Name=wootility-lekker' 'Name=Wootility'
    '';

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  multiPkgs = extraPkgs;
  extraPkgs =
    pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ ([
      udev
      wooting-udev-rules
      xorg.libxkbfile
    ]);

  meta = with lib; {
    homepage = "https://wooting.io/wootility";
    description = "Customization and management software for Wooting keyboards";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ davidtwco sodiboo ];
    mainProgram = "wootility";
  };
}
