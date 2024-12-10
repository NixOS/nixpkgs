{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "rectangle";
  version = "0.79";

  src = fetchurl {
    url = "https://github.com/rxhanson/Rectangle/releases/download/v${version}/Rectangle${version}.dmg";
    hash = "sha256-XczwgLONTt7wL+oW1ruw6wBwZTMd5VyN+79xJy0NUIg=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv Rectangle.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/rxhanson/Rectangle";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Move and resize windows in macOS using keyboard shortcuts or snap areas";
    homepage = "https://rectangleapp.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.darwin;
    maintainers = with maintainers; [
      Enzime
      Intuinewin
      wegank
    ];
    license = licenses.mit;
  };
}
