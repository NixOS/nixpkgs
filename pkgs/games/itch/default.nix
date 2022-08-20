{ lib
, stdenvNoCC
, fetchpatch
, fetchzip
, fetchFromGitHub
, butler
, electron_11
, steam-run
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:
stdenvNoCC.mkDerivation rec {
  pname = "itch";
  version = "25.5.1";

  src = fetchzip {
    url = "https://broth.itch.ovh/${pname}/linux-amd64/${version}/itch.zip";
    stripRoot = false;
    sha256 = "sha256-ejfS+sqhacW2h8u96W4fout3V8xrBs0SrW5w/7X83m4=";
  };

  patches = [
    # Fixes crash while browsing the store.
    (fetchpatch {
      name = "itch.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/itch.patch?h=itch-bin&id=0b181454567029141749f870880b10093216e133";
      sha256 = "sha256-gmLL/BMondSflERm0z+DuGDP56JhDXiyxEwLUavTD8Q=";
    })
  ];

  itch-setup = fetchzip {
    url = "https://broth.itch.ovh/itch-setup/linux-amd64/1.26.0/itch-setup.zip";
    stripRoot = false;
    sha256 = "sha256-5MP6X33Jfu97o5R1n6Og64Bv4ZMxVM0A8lXeQug+bNA=";
  };

  icons = fetchFromGitHub {
    owner = "itchio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DZBmf8fe0zw5uiQjNKXw8g/vU2hjNDa87z/7XuhyXog=";
    sparseCheckout = "release/images/itch-icons";
  };

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "itch %U";
      tryExec = pname;
      icon = pname;
      desktopName = pname;
      mimeTypes = [ "x-scheme-handler/itchio" "x-scheme-handler/itch" ];
      comment = "Install and play itch.io games easily";
      categories = [ "Game" ];
    })
  ];

  # As taken from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=itch-bin
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname}/resources/app
    cp -r resources/app "$out/share/${pname}/resources/"

    install -Dm644 LICENSE -t "$out/share/licenses/$pkgname/"
    install -Dm644 LICENSES.chromium.html -t "$out/share/licenses/$pkgname/"

    for icon in $icons/release/images/itch-icons/icon*.png
    do
      iconsize="''${icon#$icons/icon}"
      iconsize="''${iconsize%.png}"
      icondir="$out/share/icons/hicolor/''${iconsize}x''${iconsize}/apps/"
      install -Dm644 "$icon" "$icondir/itch.png"
    done

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${steam-run}/bin/steam-run $out/bin/${pname} \
      --add-flags ${electron_11}/bin/electron \
      --add-flags $out/share/${pname}/resources/app \
      --set BROTH_USE_LOCAL butler,itch-setup \
      --prefix PATH : ${butler}/bin/:${itch-setup}
  '';

  meta = with lib; {
    description = "The best way to play itch.io games";
    homepage = "https://github.com/itchio/itch";
    license = licenses.mit;
    platforms = platforms.linux;
    sourceProvenance = lib.sourceTypes.binaryBytecode;
    maintainers = with maintainers; [ pasqui23 ];
  };
}
