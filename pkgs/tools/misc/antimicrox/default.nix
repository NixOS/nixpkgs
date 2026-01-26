{
  mkDerivation,
  lib,
  cmake,
  extra-cmake-modules,
  pkg-config,
  SDL2,
  qttools,
  libxtst,
  fetchFromGitHub,
  itstool,
  udevCheckHook,
}:

mkDerivation rec {
  pname = "antimicrox";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "AntiMicroX";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZIHhgyOpabWkdFZoha/Hj/1d8/b6qVolE6dn0xAFZVw=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    itstool
    udevCheckHook
  ];
  buildInputs = [
    SDL2
    qttools
    libxtst
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
        --replace "/usr/lib/udev/rules.d/" "$out/lib/udev/rules.d/"
  '';

  doInstallCheck = true;

  meta = {
    description = "GUI for mapping keyboard and mouse controls to a gamepad";
    inherit (src.meta) homepage;
    maintainers = with lib.maintainers; [ sbruder ];
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux;
    mainProgram = "antimicrox";
  };
}
