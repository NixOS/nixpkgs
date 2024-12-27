{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  coreutils,
  fpc,
  git,
  gnugrep,
  iproute2,
  lazarus-qt6,
  libGL,
  libGLU,
  libnotify,
  libqtpas,
  libX11,
  nix-update-script,
  polkit,
  procps,
  qt6,
  systemd,
  util-linux,
  vulkan-tools,
  which,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "goverlay";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "benjamimgois";
    repo = pname;
    rev = version;
    sha256 = "sha256-tSpM+XLlFQLfL750LTNWbWFg1O+0fSfsPRXuRCm/KlY=";
  };

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'prefix = /usr/local' "prefix = $out"

    substituteInPlace overlayunit.pas \
      --replace-fail '/usr/share/icons/hicolor/128x128/apps/goverlay.png' "$out/share/icons/hicolor/128x128/apps/goverlay.png" \
      --replace-fail '/sbin/ip' "${lib.getExe' iproute2 "ip"}" \
      --replace-fail '/bin/bash' "${lib.getExe' bash "bash"}"
  '';

  nativeBuildInputs = [
    fpc
    lazarus-qt6
    wrapQtAppsHook
  ];

  buildInputs = [
    libGL
    libGLU
    libqtpas
    libX11
    qt6.qtbase
  ];

  NIX_LDFLAGS = "-lGLU -rpath ${lib.makeLibraryPath buildInputs}";

  buildPhase = ''
    runHook preBuild
    HOME=$(mktemp -d) lazbuild --lazarusdir=${lazarus-qt6}/share/lazarus -B goverlay.lpi
    runHook postBuild
  '';

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        bash
        coreutils
        git
        gnugrep
        libnotify
        polkit
        procps
        systemd
        util-linux.bin
        vulkan-tools
        which
      ]
    }"

    # Force xcb since libqt5pas doesn't support Wayland
    # See https://github.com/benjamimgois/goverlay/issues/107
    "--set QT_QPA_PLATFORM xcb"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Opensource project that aims to create a Graphical UI to help manage Linux overlays";
    homepage = "https://github.com/benjamimgois/goverlay";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "goverlay";
  };
}
