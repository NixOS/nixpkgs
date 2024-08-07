{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libvibrant,
  libxcb,
  libXrandr,
  pkg-config,
  qtbase,
  qttools,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vibrantLinux";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "libvibrant";
    repo = "vibrantLinux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GsGWQ6Os8GQ1XbRKrlTOpwPvwyfT/6ftjlt+fJ/YiK8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libvibrant
    libxcb
    libXrandr
    qtbase
    qttools
  ];

  meta = with lib; {
    description = "Tool to automate managing your screen's saturation depending on what programs are running";
    homepage = "https://github.com/libvibrant/vibrantLinux";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      Scrumplex
      unclamped
    ];
    platforms = platforms.linux;
    mainProgram = "vibrantLinux";
  };
})
