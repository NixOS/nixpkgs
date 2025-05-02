{
  lib,
  buildDubPackage,
  fetchFromGitHub,
  ncurses,
  zlib,
}:

buildDubPackage rec {
  pname = "btdu";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "CyberShadow";
    repo = "btdu";
    rev = "v${version}";
    hash = "sha256-3sSZq+5UJH02IO0Y1yL3BLHDb4lk8k6awb5ZysBQciE=";
  };

  dubLock = ./dub-lock.json;

  buildInputs = [
    ncurses
    zlib
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 btdu -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Sampling disk usage profiler for btrfs";
    homepage = "https://github.com/CyberShadow/btdu";
    changelog = "https://github.com/CyberShadow/btdu/releases/tag/${src.rev}";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ atila cybershadow ];
    mainProgram = "btdu";
  };
}
