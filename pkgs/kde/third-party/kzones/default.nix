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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "gerritdevriese";
    repo = "kzones";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JtKE66J/yJfKsS7K6j4wYd1C7A1iVcajsQA+vzL18AY=";
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
