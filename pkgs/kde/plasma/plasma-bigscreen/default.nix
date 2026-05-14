{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
  pkg-config,
  kdeconnect-kde,
  kdeclarative,
  kscreen,
  libcec,
  milou,
  plasma-nano,
  plasma-nm,
  plasma-workspace,
  plasma-wayland-protocols,
  qcoro,
  qtmultimedia,
  qtwayland,
  qtwebengine,
  sdl3,
  wayland,
}:

mkKdeDerivation {
  pname = "plasma-bigscreen";
  version = "unstable-2026-05-11";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "plasma-bigscreen";
    rev = "5602f65bcac23fc8f8a8a3f69c130da4fd00df19";
    hash = "sha256-APdiGFNLLvDk4+5igVgw/GDJnrPIkq3gmGBSvs7v/8U=";
  };

  extraNativeBuildInputs = [
    pkg-config
  ];

  extraBuildInputs = [
    libcec
    kdeconnect-kde
    kdeclarative
    kscreen
    milou
    plasma-nano
    plasma-nm
    plasma-wayland-protocols
    qcoro
    qtmultimedia
    qtwayland
    qtwebengine
    sdl3
    wayland
  ];

  dontQmlLint = true; # FIXME: qmllint fails to resolve Bigscreen's nested QML import paths.

  extraCmakeFlags = [
    # FIXME: work around Qt 6.10 cmake API changes
    "-DQT_FIND_PRIVATE_MODULES=1"
  ];

  postPatch = ''
    substituteInPlace bin/plasma-bigscreen-wayland.in \
      --replace-fail @KDE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"

    substituteInPlace bin/plasma-bigscreen-wayland.desktop.cmake \
      --replace-fail @CMAKE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"

    # Plasma version numbers are required to match, but we are building an
    # unreleased package against a stable Plasma release.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(PROJECT_VERSION "6.5.80")' 'set(PROJECT_VERSION "${plasma-workspace.version}")'
  '';

  passthru.providedSessions = [ "plasma-bigscreen-wayland" ];

  meta = {
    platforms = lib.platforms.linux;
  };
}
