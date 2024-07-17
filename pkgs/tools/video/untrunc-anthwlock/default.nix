{
  lib,
  stdenv,
  fetchFromGitHub,
  ffmpeg_4,
  libui,
  unstableGitUpdater,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "untrunc-anthwlock";
  version = "0-unstable-2021-11-21";

  src = fetchFromGitHub {
    owner = "anthwlock";
    repo = "untrunc";
    rev = "d72ec324fbc29eb00b53c7dafeef09f92308962b";
    hash = "sha256-h+aFPhlbEM6EfCKbsJPelBY5ys7kv5K4rbK/HTHeEcw=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = [
    ffmpeg_4
    libui
  ];

  buildPhase = ''
    runHook preBuild
    make IS_RELEASE=1 untrunc
    make IS_RELEASE=1 untrunc-gui
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D -t $out/bin untrunc untrunc-gui
    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater {
    # Only stale "latest" tag
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    description = "Restore a truncated mp4/mov (improved version of ponchio/untrunc)";
    homepage = "https://github.com/anthwlock/untrunc";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
