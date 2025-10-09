{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  pkg-config,
  cmake,
  yaml-cpp,
  libevdev,
  udev,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "interception-tools";
  version = "0.6.8";
  src = fetchFromGitLab {
    owner = "interception/linux";
    repo = "tools";
    rev = "v${version}";
    hash = "sha256-jhdgfCWbkF+jD/iXsJ+fYKOtPymxcC46Q4w0aqpvcek=";
  };

  patches = [
    (fetchpatch {
      name = "Bump-CMake-minimum-version-to-3.10";
      url = "https://gitlab.com/interception/linux/tools/-/commit/110c9b39b54eae9acd16fa6d64539ce9886b5684.patch";
      hash = "sha256-vLm7LvXh/pGA12gUpt9vt2XTWFqkdjQFOyRzaDRghHI=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libevdev
    udev
    yaml-cpp
    boost
  ];

  meta = {
    description = "Minimal composable infrastructure on top of libudev and libevdev";
    homepage = "https://gitlab.com/interception/linux/tools";
    changelog = "https://gitlab.com/interception/linux/tools/-/tags/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.vyp ];
    platforms = lib.platforms.linux;
  };
}
