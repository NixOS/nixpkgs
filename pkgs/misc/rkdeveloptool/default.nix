{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libusb1 }:

stdenv.mkDerivation {
  pname = "rkdeveloptool";
  version = "unstable-2019-07-01";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkdeveloptool";
    rev = "6e92ebcf8b1812da02663494a68972f956e490d3";
    sha256 = "0zwrkqfxd671iy69v3q0844gfdpm1yk51i9qh2rqc969bd8glxga";
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
