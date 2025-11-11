{
  lib,
  stdenv,
  fetchFromGitLab,

  cmake,
  extra-cmake-modules,
  wrapQtAppsHook,

  kauth,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kirigami-addons,
  kirigami,
  kitemmodels,
  libselinux,
  libsepol,
  modemmanager-qt,
  networkmanager-qt,
  pcre,
  kcmutils,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-settings";
  version = "25.11.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma-mobile";
    repo = "plasma-settings";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OCOZQOkg2BHq78gmQgtMWuyMwWJRRqe/NIDlDk3M5NU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    kauth
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami-addons
    kirigami
    kitemmodels
    libselinux
    libsepol
    modemmanager-qt
    networkmanager-qt
    pcre
    kcmutils
    util-linux
  ];

  meta = with lib; {
    description = "Settings application for Plasma Mobile";
    mainProgram = "plasma-settings";
    homepage = "https://invent.kde.org/plasma-mobile/plasma-settings";
    # https://invent.kde.org/plasma-mobile/plasma-settings/-/commit/a59007f383308503e59498b3036e1483bca26e35
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kurnevsky ];
  };
})
