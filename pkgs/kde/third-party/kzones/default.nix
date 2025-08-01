{
  lib,
  stdenv,
  fetchFromGitHub,
  kpackage,
  kwin,
  zip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kzones";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "gerritdevriese";
    repo = "kzones";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xqTQiL+7T6p+Y86eC5InAk6waYoM82iFoLflkN6/dG8=";
  };

  nativeBuildInputs = [
    kpackage
    zip
  ];
  buildInputs = [ kwin ];
  dontWrapQtApps = true;

  buildFlags = [ "build" ];

  installPhase = ''
    runHook preInstall

    kpackagetool6 --type=KWin/Script --install=kzones.kwinscript --packageroot=$out/share/kwin/scripts

    runHook postInstall
  '';

  meta = {
    description = "KDE KWin Script for snapping windows into zones";
    homepage = "https://github.com/gerritdevriese/kzones/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
  };
})
