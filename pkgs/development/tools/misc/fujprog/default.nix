{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, IOKit
, libftdi1
, libusb-compat-0_1
}:

stdenv.mkDerivation rec {
  pname = "fujprog";
  version = "4.6";

  src = fetchFromGitHub {
    owner = "kost";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "04l5rrfrp3pflwz5ncwvb4ibbsqib2259m23bzfi8m80aj216shd";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
  ];

  buildInputs = [
    libftdi1
    libusb-compat-0_1
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "JTAG programmer for the ULX3S and ULX2S open hardware FPGA development boards";
    homepage = "https://github.com/kost/fujprog";
    license = licenses.bsd2;
    maintainers = with maintainers; [ trepetti ];
    platforms = platforms.all;
    changelog = "https://github.com/kost/fujprog/releases/tag/v${version}";
  };
}
