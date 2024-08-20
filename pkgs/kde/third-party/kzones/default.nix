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
  version = "0.8";

  src = fetchFromGitHub {
    owner = "gerritdevriese";
    repo = "kzones";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6cZJEcvynlP9nXyBKRst8Bca0d8Mh51ft7ocRrgCV7w=";
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
