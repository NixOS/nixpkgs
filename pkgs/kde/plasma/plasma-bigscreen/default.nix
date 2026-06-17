{
  mkKdeDerivation,
  plasma-workspace,
  pkg-config,
  qtwebengine,
  libcec,
  sdl3,
}:

mkKdeDerivation {
  pname = "plasma-bigscreen";

  postPatch = ''
    substituteInPlace bin/plasma-bigscreen-wayland.in \
      --replace-fail @KDE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"

    substituteInPlace bin/plasma-bigscreen-wayland.desktop.cmake \
      --replace-fail @CMAKE_INSTALL_FULL_LIBEXECDIR@ "${plasma-workspace}/libexec"
  '';

  extraCmakeFlags = [
    "-DQT_FIND_PRIVATE_MODULES=ON"
  ];

  extraNativeBuildInputs = [
    pkg-config
  ];

  extraBuildInputs = [
    qtwebengine

    libcec
    sdl3
  ];

  dontQmlLint = true;

  passthru.providedSessions = [ "plasma-bigscreen-wayland" ];
}
