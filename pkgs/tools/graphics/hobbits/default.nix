{ lib, stdenv, mkDerivation, fetchFromGitHub
, cmake, pkg-config, fftw, libpcap, libusb1, python3
}:

mkDerivation rec {
  pname = "hobbits";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "Mahlet-Inc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GZHBkBRt1ySItV+h5rdvey7KwdUWh5+rgztXh6HW3Js=";
  };

  postPatch = ''
    substituteInPlace src/hobbits-core/settingsdata.cpp \
      --replace "pythonHome = \"/usr\"" "pythonHome = \"${python3}\""
    substituteInPlace cmake/gitversion.cmake \
      --replace "[Mystery Build]" "${version}"
  '';

  buildInputs = [ fftw libpcap libusb1 python3 ];

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "A multi-platform GUI for bit-based analysis, processing, and visualization";
    homepage = "https://github.com/Mahlet-Inc/hobbits";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
