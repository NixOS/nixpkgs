{ lib
, stdenv
, fetchFromGitHub
, which
, SDL2
, perl
, pkg-config
, wrapGAppsHook
, gtk3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jfsw";
  version = "20211225";

  src = fetchFromGitHub {
    owner = "jonof";
    repo = "jfsw";
    rev = "refs/tags/${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-oRJHVsVo+KQfJyd8TcPxTMPPi993qxQb0wnD9nR4vJY=";
  };

  nativeBuildInputs = [
    which
    SDL2
    perl
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    SDL2
    gtk3
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 sw -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Modern port the original Shadow Warrior";
    homepage = "http://www.jonof.id.au/jfsw/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "sw";
    maintainers = with lib.maintainers; [ moody ];
    broken = stdenv.isDarwin;
    inherit (SDL2.meta) platforms;
  };
})
