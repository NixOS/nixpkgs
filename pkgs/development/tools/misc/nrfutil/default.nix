{ lib
, stdenv
, fetchFromGitHub
, pkgs
, python3
, python3Packages
}:
let
  py = python3.override {
    packageOverrides = self: super: {

      libusb1 = super.libusb1.overridePythonAttrs (oldAttrs: rec {
        version = "1.9.3";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0j8p7jb7sibiiib18vyv3w5rrk0f4d2dl99bs18nwkq6pqvwxrk0";
        };

        postPatch = ''
          substituteInPlace usb1/libusb1.py --replace \
            "ctypes.util.find_library(base_name)" \
            "'${pkgs.libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}'"
        '';
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "nrfutil";
  version = "6.1.3";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "pc-nrfutil";
    rev = "v${version}";
    sha256 = "1gpxjdcjn4rjvk649vpkh563c7lx3rrfvamazb1qjii1pxrvvqa7";
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
  '';

  meta = with lib; {
    description = "Device Firmware Update tool for nRF chips";
    homepage = "https://github.com/NordicSemiconductor/pc-nrfutil";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
