{ stdenv, python2Packages, fetchFromGitHub }:

with python2Packages; buildPythonApplication rec {
  pname = "nrfutil";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "pc-nrfutil";
    rev = "v${version}";
    sha256 = "1hajjgz8r4fjbwqr22p5dvb6k83dpxf8k7mhx20gkbrrx9ivqh79";
  };

  propagatedBuildInputs = [ pc-ble-driver-py six pyserial enum34 click ecdsa
    protobuf tqdm piccata pyspinel intelhex pyyaml crcmod libusb1 ipaddress ];

  checkInputs = [ nose behave ];

  postPatch = ''
    # remove version bound on pyyaml
    sed -i /pyyaml/d requirements.txt

    mkdir test-reports
  '';

  meta = with stdenv.lib; {
    description = "Device Firmware Update tool for nRF chips";
    homepage = "https://github.com/NordicSemiconductor/pc-nrfutil";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
