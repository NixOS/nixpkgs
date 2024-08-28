{ lib, stdenv, fetchFromGitHub, ffmpeg_7, libui, unstableGitUpdater, wrapGAppsHook3 }:

stdenv.mkDerivation {
  pname = "untrunc-anthwlock";
  version = "0-unstable-2024-08-14";

  src = fetchFromGitHub {
    owner = "anthwlock";
    repo = "untrunc";
    rev = "13cafedf59369db478af537fb909f0d7fd0eb85f";
    hash = "sha256-4GIPj8so7POEwxKZzFBoJTu76XKbGHYmXC/ILeo0dVE=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ];

  buildInputs = [ ffmpeg_7 libui ];

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
