{
  mkKdeDerivation,
  lib,
  fetchFromGitLab,
  pkg-config,
  libevdev,
  libcec,
  libcec_platform,
  plasma-workspace,
  sdl3,
  xwiimote,
}:

mkKdeDerivation {
  pname = "plasma-remotecontrollers";
  version = "0-unstable-2026-06-06";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma-bigscreen";
    repo = "plasma-remotecontrollers";
    rev = "3ee2a2a1c23759db74890e644f341a1969d4fe4f";
    hash = "sha256-DgixSiQe4GGC4TMvtAOfEK+IJQp74f6GUu8gHPrX8wM=";
  };

  extraNativeBuildInputs = [
    pkg-config
  ];

  extraBuildInputs = [
    libevdev
    libcec
    libcec_platform
    sdl3
    xwiimote
  ];

  postPatch = ''
    # Plasma version numbers are required to match, but we are building an
    # unreleased package against a stable Plasma release.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(PROJECT_VERSION "6.4.50")' 'set(PROJECT_VERSION "${plasma-workspace.version}")'
  '';

  meta = {
    # Waiting on https://invent.kde.org/plasma-bigscreen/plasma-remotecontrollers/-/merge_requests/71
    # To simplify/autofill
    license = with lib.licenses; [
      bsd2
      cc0
      gpl2Only
      gpl2Plus
      gpl3Only
      lgpl2Plus
      lgpl21Only
      lgpl3Only
      gpl3Plus # LicenseRef-KDE-Accepted-GPL
      lgpl3Plus # LicenseRef-KDE-Accepted-LGPL
    ];
    platforms = lib.platforms.linux;
  };
}
