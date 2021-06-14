{ lib, stdenv, fetchFromGitLab, pkg-config, cmake, libyamlcpp,
  libevdev, udev, boost }:

stdenv.mkDerivation rec {
  pname = "interception-tools";
  version = "0.6.6";
  src = fetchFromGitLab {
    owner = "interception/linux";
    repo = "tools";
    rev = "v${version}";
    sha256 = "0k9h14a9d65nwvv7pj0kigjgzfv453mm3r4svnxfg1h5lccmy8jj";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libevdev udev libyamlcpp boost ];

  prePatch = ''
    substituteInPlace CMakeLists.txt --replace \
      '"/usr/include/libevdev-1.0"' \
      "\"$(pkg-config --cflags libevdev | cut -c 3-)\""
  '';

  meta = {
    description = "A minimal composable infrastructure on top of libudev and libevdev";
    homepage = "https://gitlab.com/interception/linux/tools";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.vyp ];
    platforms = lib.platforms.linux;
  };
}
