{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  SDL2,
  SDL2_image,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brogue-ce";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "tmewett";
    repo = "BrogueCE";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FUIdi1Ytn+INeD9550MW41qXtLb6in0QS3Snt8QaXUA=";
  };

  postPatch = ''
    substituteInPlace linux/brogue-multiuser.sh \
      --replace broguedir= "broguedir=$out/opt/brogue-ce #"
  '';

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    SDL2
    SDL2_image
  ];

  makeFlags = [ "DATADIR=$(out)/opt/brogue-ce" ];

  desktopItems = [
    (makeDesktopItem {
      name = "brogue-ce";
      desktopName = "Brogue CE";
      genericName = "Roguelike";
      comment = "Brave the Dungeons of Doom!";
      icon = "brogue-ce";
      exec = "brogue-ce";
      categories = [
        "Game"
        "AdventureGame"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt
    cp -r bin $out/opt/brogue-ce
    install -Dm755 linux/brogue-multiuser.sh $out/bin/brogue-ce
    install -Dm 644 bin/assets/icon.png $out/share/icons/hicolor/256x256/apps/brogue-ce.png
    runHook postInstall
  '';

  meta = with lib; {
    description = "A community-lead fork of the minimalist roguelike game Brogue";
    mainProgram = "brogue-ce";
    homepage = "https://github.com/tmewett/BrogueCE";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      AndersonTorres
      fgaz
    ];
    platforms = platforms.all;
  };
})
