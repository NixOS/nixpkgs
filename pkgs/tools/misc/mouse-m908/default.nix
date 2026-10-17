{ lib, stdenv, fetchFromGitHub, libusb1, cmake, udev, pkg-config }:

stdenv.mkDerivation rec {
  pname = "mouse-m908";
  version = "3.3";
  tag = "v${version}";

  src = fetchFromGitHub {
    owner = "dokutan";
    repo = "mouse_m908";
    rev = tag;
    sha256 = "sha256-jat5K7P3Z5R1L5jI4pilNFU7q0xtRxwd4oXMYRW0mUU=";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ libusb1 ];

  meta = with lib; {
    description = "An application to configure Redragon mice.";
    homepage = "https://github.com/dokutan/mouse_m908";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rferris ];
    platforms = platforms.linux;
  };
}
