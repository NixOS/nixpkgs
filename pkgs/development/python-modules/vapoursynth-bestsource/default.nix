{
  lib,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  meson-python,
  ninja,
  pkg-config,
  vapoursynth,
  ffmpeg,
  xxhash,
  libp2p,
  gitUpdater,
  vulkan-headers,
  avisynthplus,
}:

buildPythonPackage (finalAttrs: {
  pname = "vapoursynth-bestsource";
  version = "23";

  pyproject = true;

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "vapoursynth";
    repo = "bestsource";
    tag = "R${finalAttrs.version}";
    hash = "sha256-ID0s4eIcRC0RKx6i15vufjq+AdSvSnaaUFjdvsvMzBc=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace-fail avisynthplus avisynth
  '';

  build-system = [ meson-python ];

  nativeBuildInputs = [
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    (ffmpeg.override { withLcms2 = true; })
    pkgs.xxhash
    libp2p
    vulkan-headers
    avisynthplus.dev
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "R";
    ignoredVersions = "*-RC*";
  };

  meta = {
    description = "Wrapper library around FFmpeg that ensures sample and frame accurate access to audio and video";
    homepage = "https://github.com/vapoursynth/bestsource";
    license = with lib.licenses; [
      mit
      wtfpl
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.all;
  };
})
