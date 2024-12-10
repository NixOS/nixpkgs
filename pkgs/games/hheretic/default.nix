{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL,
  SDL_mixer,
  autoreconfHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hheretic";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "sezero";
    repo = "hheretic";
    rev = "hheretic-${finalAttrs.version}";
    hash = "sha256-e9N869W8STZdLUBSscxEnF2Z+SrdVv8ARDL8AMe1SJ8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    SDL.dev
  ];

  buildInputs = [
    SDL
    SDL_mixer
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  configureFlags = [ "--with-audio=sdlmixer" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 hheretic-gl -t $out/bin

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "hheretic-";
  };

  meta = {
    description = "Linux port of Raven Game's Heretic";
    homepage = "https://hhexen.sourceforge.net/hhexen.html";
    license = lib.licenses.gpl2Plus;
    mainProgram = "hheretic-gl";
    maintainers = with lib.maintainers; [ moody ];
    inherit (SDL.meta) platforms;
    broken = stdenv.isDarwin;
  };
})
