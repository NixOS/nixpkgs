{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, libusb1 }:

stdenv.mkDerivation {
  pname = "rkdeveloptool";
  version = "unstable-2021-02-03";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkdeveloptool";
    rev = "e607a5d6ad3f6af66d3daf3f6370e6dc9763a20d";
    sha256 = "08m0yfds5rpr5l0s75ynfarq3hrv94l3aadld17cz5gqapqcfs2n";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libusb1 ];

  # main.cpp:1568:36: error: '%s' directive output may be truncated writing up to 557 bytes into a region of size 5
  CPPFLAGS = "-Wno-error=format-truncation";

  meta = with lib; {
    homepage = "https://github.com/rockchip-linux/rkdeveloptool";
    description = "A tool from Rockchip to communicate with Rockusb devices";
    license = licenses.gpl2;
    maintainers = [ maintainers.lopsided98 ];
  };
}
