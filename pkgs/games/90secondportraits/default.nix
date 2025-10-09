{
  lib,
  stdenv,
  fetchurl,
  love,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

let
  pname = "90secondportraits";

  icon = fetchurl {
    url = "http://tangramgames.dk/img/thumb/90secondportraits.png";
    sha256 = "13k6cq8s7jw77j81xfa5ri41445m778q6iqbfplhwdpja03c6faw";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "90secondportraits";
      exec = pname;
      icon = icon;
      comment = "A silly speed painting game";
      desktopName = "90 Second Portraits";
      genericName = "90secondportraits";
      categories = [ "Game" ];
    })
  ];

in
stdenv.mkDerivation rec {
  inherit pname desktopItems;
  version = "1.01b";

  src = fetchurl {
    url = "https://github.com/SimonLarsen/90-Second-Portraits/releases/download/${version}/${pname}-${version}.love";
    sha256 = "0jj3k953r6vb02212gqcgqpb4ima87gnqgls43jmylxq2mcm33h5";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm444 $src $out/share/games/lovegames/${pname}.love
    makeWrapper ${love}/bin/love $out/bin/${pname} \
      --add-flags $out/share/games/lovegames/${pname}.love
    runHook postInstall
  '';

  meta = with lib; {
    description = "Silly speed painting game";
    mainProgram = "90secondportraits";
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
    license = with licenses; [
      zlib
      cc-by-sa-40
      cc-by-sa-30 # vendored
      x11
      mit
    ];
    downloadPage = "http://tangramgames.dk/games/90secondportraits";
  };

}
