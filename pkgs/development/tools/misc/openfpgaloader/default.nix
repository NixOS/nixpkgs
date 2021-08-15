{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, libftdi1
, libusb1
, udev
}:

stdenv.mkDerivation rec {
  pname = "openfpgaloader";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "trabucayre";
    repo = "openFPGALoader";
    rev = "v${version}";
    sha256 = "sha256-g1mr7S9Z70A+dXWptZPLHt90JpuclJAEDwUTicpxtic=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libftdi1
    libusb1
    udev
  ];

  meta = with lib; {
    description = "Universal utility for programming FPGAs";
    homepage = "https://github.com/trabucayre/openFPGALoader";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ danderson ];
  };
}
