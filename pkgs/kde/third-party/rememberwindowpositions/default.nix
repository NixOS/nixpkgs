{
  lib,
  fetchFromGitHub,
  stdenv,

  zip,
  kwin,
  kpackage,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rememberwindowpositions";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "rxappdev";
    repo = "RememberWindowPositions";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dZGwtW9IGAsXj6mbek6oYNWquv6Da6vXw03a1wAPAzo=";
  };

  buildInputs = [
    kpackage
    zip
  ];

  nativeBuildInputs = [
    kwin
  ];

  buildFlags = [ "build" ];
  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    kpackagetool6 --type=KWin/Script --install rememberwindowpositions.kwinscript --packageroot=$out/share/kwin/scripts
    runHook postInstall
  '';

  meta = {
    description = "Remember window positions for apps in KDE Plasma 6+. Especially useful for multi-window applications such as browsers.";
    homepage = "https://github.com/rxappdev/RememberWindowPositions";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nukdokplex ];
    platforms = lib.platforms.all;
  };
})
