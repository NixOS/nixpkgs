{ lib
, stdenv
, fetchFromGitHub
, which
, SDL2
, perl
, pkg-config
, wrapGAppsHook3
, gtk3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jfsw";
  version = "20240303";

  src = fetchFromGitHub {
    owner = "jonof";
    repo = "jfsw";
    rev = "refs/tags/${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-bOUgRa9zWufTFEj5huXAKeRerV8PqfqQVDoVUvRrj2I=";
  };

  nativeBuildInputs = [
    which
    SDL2
    perl
    pkg-config
    wrapGAppsHook3
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
