{ stdenv, fetchurl, pkgconfig, cmake, libyamlcpp,
  libevdev, udev }:

let
  version = "0.1.1";
  baseName = "interception-tools";
in stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "https://gitlab.com/interception/linux/tools/repository/v${version}/archive.tar.gz";
    sha256 = "14g4pphvylqdb922va322z1pbp12ap753hcf7zf9sii1ikvif83j";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libevdev udev libyamlcpp ];

  prePatch = ''
    substituteInPlace CMakeLists.txt --replace \
      '"/usr/include/libevdev-1.0"' \
      "\"$(pkg-config --cflags libevdev | cut -c 3-)\""
  '';

  patches = [ ./fix-udevmon-configuration-job-path.patch ];

  meta = {
    description = "A minimal composable infrastructure on top of libudev and libevdev";
    homepage = "https://gitlab.com/interception/linux/tools";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.vyp ];
    platforms = stdenv.lib.platforms.linux;
  };
}
