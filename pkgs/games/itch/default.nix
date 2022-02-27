{ lib
, stdenvNoCC
, fetchurl
, libnotify
, nss
, gtk3
, fetchFromGitHub
, makeDesktopItem
, itch-setup
, runtimeShell
}:
stdenvNoCC.mkDerivation rec{
  pname = "itch";
  version = "25.5.1";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Pi3l3uK4kr+N3p7fGQuqckYIzycRqJHDVX00reoSbp4=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      tryExec = "itch %U";
      icon = pname;
      desktopName = pname;
      mimeTypes = [ "x-scheme-handler/itchio" "x-scheme-handler/itch" ];
      comment = "Install and play itch.io games easily";
      categories = [ "Game" ];
    })
  ];

  itchBin = ''
    #!${runtimeShell}
    exec ${itch-setup}/bin/itch-setup --prefer-launch -- "$@"
  '';

  passAsFile = [ "itchBin" ];

  # as taken from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=itch
  installPhase = ''
    install -Dm0777 $itchBinPath $out/bin/itch
    for icon in release/images/itch-icons/icon*.png
    do
      iconsize="''${icon#release/images/itch-icons/icon}"
      iconsize="''${iconsize%.png}"
      icondir="$out/share/icons/hicolor/''${iconsize}x''${iconsize}/apps/"
      install -Dm644 "$icon" "$icondir/itch.png"
    done
  '';

  meta = with lib; {
    description = "The best way to play itch.io games";
    homepage = "https://github.com/itchio/itch";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pasqui23 ];
  };
}
