{ lib, stdenv, fetchFromGitLab, pkg-config, cmake, yaml-cpp,
  libevdev, udev, boost }:

stdenv.mkDerivation rec {
  pname = "interception-tools";
  version = "0.6.8";
  src = fetchFromGitLab {
    owner = "interception/linux";
    repo = "tools";
    rev = "v${version}";
    sha256 = "sha256-jhdgfCWbkF+jD/iXsJ+fYKOtPymxcC46Q4w0aqpvcek=";
  };

  # Fix PATH forwarding to child processes.
  # See #126681 issue for more information
  patches = [ ./interception-tools-udevmon-path-fix.patch ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libevdev udev yaml-cpp boost ];

  meta = {
    description = "A minimal composable infrastructure on top of libudev and libevdev";
    homepage = "https://gitlab.com/interception/linux/tools";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.vyp ];
    platforms = lib.platforms.linux;
  };
}
