<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, SDL
, SDL_mixer
, autoreconfHook
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hhexen";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "sezero";
    repo = "hhexen";
    rev = "hhexen-${finalAttrs.version}";
    hash = "sha256-y3jKfU4e8R2pJQN/FN7W6KQ7D/P+7pmQkdmZug15ApI=";
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

    install -Dm755 hhexen-gl -t $out/bin

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "hhexen-";
  };

  meta = {
    description = "Linux port of Raven Game's Hexen";
    homepage = "https://hhexen.sourceforge.net/hhexen.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ moody djanatyn ];
    mainProgram = "hhexen-gl";
    inherit (SDL.meta) platforms;
    broken = stdenv.isDarwin;
  };
})
=======
{ lib, fetchurl, SDL, stdenv }:

stdenv.mkDerivation rec {
  pname = "hhexen";
  version = "1.6.3";
  src = fetchurl {
    url = "mirror://sourceforge/hhexen/hhexen-${version}-src.tgz";
    sha256 = "1jwccqawbdn0rjn5p59j21rjy460jdhps7zwn2z0gq9biggw325b";
  };

  buildInputs = [ SDL ];
  installPhase = ''
    install -Dm755 hhexen-gl -t $out/bin
  '';

  meta = with lib; {
    description = "Linux port of Raven Game's Hexen";
    homepage = "https://hhexen.sourceforge.net/hhexen.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ djanatyn ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
