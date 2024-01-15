{ lib
, stdenvNoCC
, fetchzip
, fetchFromGitHub
, butler
, electron
, steam-run
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:
stdenvNoCC.mkDerivation rec {
  pname = "itch";
  version = "26.1.2";

  # TODO: Using kitch instead of itch, revert when possible
  src = fetchzip {
    url = "https://broth.itch.ovh/k${pname}/linux-amd64/${version}/archive/default#.zip";
    stripRoot = false;
    sha256 = "sha256-thXe+glpltSiKNGIRgvOZQZPJWfDHWo3dLdziyp2BM4=";
  };

  itch-setup = fetchzip {
    url = "https://broth.itch.ovh/itch-setup/linux-amd64/1.26.0/itch-setup.zip";
    stripRoot = false;
    sha256 = "sha256-5MP6X33Jfu97o5R1n6Og64Bv4ZMxVM0A8lXeQug+bNA=";
  };

  icons = let sparseCheckout = "/release/images/itch-icons"; in
    fetchFromGitHub {
        owner = "itchio";
        repo = pname;
        rev = "v${version}-canary";
        sha256 = "sha256-veZiKs9qHge+gCEpJ119bAT56ssXJAH3HBcYkEHqBFg=";
        sparseCheckout = [ sparseCheckout ];
      } + sparseCheckout;

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

    # TODO: Remove when the next stable Itch is stabilized
    substituteInPlace ./resources/app/package.json \
      --replace "kitch" "itch"

    mkdir -p $out/bin $out/share/${pname}/resources/app
    cp -r resources/app "$out/share/${pname}/resources/"

    install -Dm644 LICENSE -t "$out/share/licenses/$pkgname/"
    install -Dm644 LICENSES.chromium.html -t "$out/share/licenses/$pkgname/"

    for icon in $icons/icon*.png
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
      --add-flags ${electron}/bin/electron \
      --add-flags $out/share/${pname}/resources/app \
      --set BROTH_USE_LOCAL butler,itch-setup \
      --prefix PATH : ${butler}/bin/:${itch-setup}
  '';

  meta = with lib; {
    description = "The best way to play itch.io games";
    homepage = "https://github.com/itchio/itch";
    license = licenses.mit;
    platforms = platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = with maintainers; [ pasqui23 ];
  };
}
