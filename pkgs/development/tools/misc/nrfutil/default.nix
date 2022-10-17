{ lib
, stdenv
, fetchFromGitHub
, python3
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "nrfutil";
  version = "6.1.6";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "pc-nrfutil";
    rev = "v${version}";
    sha256 = "sha256-UiGNNJxNSpIzpeYMlzocLG2kuetl8xti5A3n6zz0lcY=";
  };

  propagatedBuildInputs = [
    click
    crcmod
    ecdsa
    libusb1
    intelhex
    pc-ble-driver-py
    piccata
    protobuf
    pyserial
    pyspinel
    pyyaml
    tqdm
  ];

  checkInputs = [
    behave
    nose
  ];

  postPatch = ''
    mkdir test-reports
    substituteInPlace requirements.txt --replace "libusb1==1.9.3" "libusb1"
  '';

  meta = with lib; {
    description = "Device Firmware Update tool for nRF chips";
    homepage = "https://github.com/NordicSemiconductor/pc-nrfutil";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
