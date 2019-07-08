{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libusb1 }:

stdenv.mkDerivation {
  pname = "rkdeveloptool";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkdeveloptool";
    rev = "081d237ad5bf8f03170c9d60bd94ceefa0352aaf";
    sha256 = "05hh7j3xgb8l1k1v2lis3nvlc0gp87ihzg6jci7m5lkkm5qgv3ji";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libusb1 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/rockchip-linux/rkdeveloptool;
    description = "A tool from Rockchip to communicate with Rockusb devices";
    license = licenses.gpl2;
    maintainers = [ maintainers.lopsided98 ];
  };
}
