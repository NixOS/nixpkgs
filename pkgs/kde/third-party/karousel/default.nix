{
  lib,
  stdenv,
  fetchFromGitHub,
  kpackage,
  kwin,
  nodejs,
  typescript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "karousel";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "peterfajdiga";
    repo = "karousel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lI3VaCd4eYhWbnYLEIeFiB88SWjd/DF8CUGFmxEXDXo=";
  };

  postPatch = ''
    patchShebangs run-ts.sh
  '';

  nativeBuildInputs = [
    kpackage
    nodejs
    typescript
  ];
  buildInputs = [ kwin ];
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    kpackagetool6 --type=KWin/Script --install=./package --packageroot=$out/share/kwin/scripts

    runHook postInstall
  '';

  meta = {
    description = "Scrollable tiling Kwin script";
    homepage = "https://github.com/peterfajdiga/karousel";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
  };
})
