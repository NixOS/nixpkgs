{
  mkKdeDerivation,
  lib,
  fetchgit,
  pkg-config,
  ki18n,
  kdeclarative,
  kcmutils,
  knotifications,
  kio,
  kwayland,
  kwindowsystem,
  plasma-workspace,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "plasma-bigscreen";
  version = "unstable-2025-07-25";

  src = fetchgit {
    url = "https://invent.kde.org/plasma/plasma-bigscreen.git";
    rev = "37dcff3aa008256f0c2260fbf66e4382d0391ac4";
    hash = "sha256-Xzp9OuR5UOPi0NWJIXP4l4ys73vcqOj/iVmcA/bIlDw=";
  };

  extraNativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ki18n
    kdeclarative
    kcmutils
    knotifications
    kio
    kwayland
    kwindowsystem
    plasma-workspace
    qtmultimedia
  ];

  postPatch = ''
    substituteInPlace bin/plasma-bigscreen-wayland.in \
      --replace @KDE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"

    # Plasma version numbers are required to match, but we are building an
    # unreleased package against a stable Plasma release.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(PROJECT_VERSION "6.4.80")' 'set(PROJECT_VERSION "${plasma-workspace.version}")'
  '';

  preFixup = ''
    wrapQtApp $out/bin/plasma-bigscreen-wayland
  '';

  passthru.providedSessions = [
    "plasma-bigscreen-wayland"
  ];

  meta = {
    license = lib.licenses.gpl2Plus;
  };
}
