{ lib, stdenv, fetchFromGitLab, pkg-config, cmake, libyamlcpp,
  libevdev, udev, boost }:

stdenv.mkDerivation rec {
  pname = "interception-tools";
  version = "0.6.7";
  src = fetchFromGitLab {
    owner = "interception/linux";
    repo = "tools";
    rev = "v${version}";
    sha256 = "0wcmppa7092b33wb8vc782day5phf90pc25cn1x7rk0rlw565z36";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libevdev udev libyamlcpp boost ];

  meta = {
    description = "A minimal composable infrastructure on top of libudev and libevdev";
    homepage = "https://gitlab.com/interception/linux/tools";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.vyp ];
    platforms = lib.platforms.linux;
  };
}
