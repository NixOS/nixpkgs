{ lib, python3Packages, fetchFromGitHub }:

with python3Packages; buildPythonApplication rec {
  pname = "nrfutil";
  version = "6.1";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "pc-nrfutil";
    rev = "v${version}";
    sha256 = "0g43lf5jmk0qxb7r4h68wr38fli6pjjk67w8l2cpdm9rd8jz4lpn";
  };

  propagatedBuildInputs = [ pc-ble-driver-py six pyserial enum34  click ecdsa
    protobuf tqdm piccata pyspinel intelhex pyyaml crcmod libusb1 ipaddress ];

  checkInputs = [ nose behave ];

  postPatch = ''
    mkdir test-reports
  '';

  meta = with lib; {
    description = "Device Firmware Update tool for nRF chips";
    homepage = "https://github.com/NordicSemiconductor/pc-nrfutil";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
