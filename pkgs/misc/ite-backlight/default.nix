{ lib
, pkgs
, stdenv
, ninja
, libusb1
, meson
, boost
, fetchFromGitHub
, pkg-config
, microsoft_gsl
}:

stdenv.mkDerivation rec {
  pname = "ite-backlight";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "hexagonal-sun";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hany4bn93mac9qyz97r1l858d48zdvvmn3mabzr3441ivqr9j0a";
  };

  nativeBuildInputs = [
    ninja
    pkg-config
    meson
    microsoft_gsl
  ];

  buildInputs = [
    boost
    libusb1
  ];

  meta = with lib; {
    description = "Commands to control ite-backlight devices";
    longDescription = ''
      This project aims to provide a set of simple utilities for controlling ITE 8291
      keyboard backlight controllers.
    '';
    license = with licenses; [ mit ];
    homepage = "https://github.com/hexagonal-sun/ite-backlight";
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexagonal-sun ];
  };
}
