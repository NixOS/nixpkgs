{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libusb1
, libftdi
, cargo-readme
, pkg-config
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "humility";
  version = "unstable-2022-09-15";

  nativeBuildInputs = [ pkg-config cargo-readme ];
  buildInputs = [ libusb1 libftdi ] ++ lib.optionals stdenv.isDarwin [
    AppKit
  ];

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = pname;
    rev = "d336c21c7b6da7f8203a9331c7657581de2bc6ad";
    sha256 = "sha256-yW7QcxTWbL2YsV2bvfhbqQ2nawlPQbYxBfIGCWo28GY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "capstone-0.10.0" = "sha256-x0p005W6u3QsTKRupj9HEg+dZB3xCXlKb9VCKv+LJ0U=";
      "hidapi-1.4.1" = "sha256-2SBQu94ArGGwPU3wJYV0vwwVOXMCCq+jbeBHfKuE+pA=";
      "hif-0.3.1" = "sha256-o3r1akaSARfqIzuP86SJc6/s0b2PIkaZENjYO3DPAUo=";
      "idol-0.2.0" = "sha256-T4wxeSTH2tFBR8L5wL5a0gLDfcRLpALyGBE0dYNQwLI=";
      "idt8a3xxxx-0.1.0" = "sha256-S36fS9hYTIn57Tt9msRiM7OFfujJEf8ED+9R9p0zgK4=";
      "libusb1-sys-0.5.0" = "sha256-7Bb1lpZvCb+OrKGYiD6NV+lMJuxFbukkRXsufaro5OQ=";
      "pmbus-0.1.0" = "sha256-KBc7gFwrN1jv1HXygda7qE3ZYNWAO10Wl3X6alc2JOE=";
      "probe-rs-0.12.0" = "sha256-L2kQNAdSvv5x1goELuy3pZZzmoUDc4tMX3OJ7A5rAD0=";
      "serialport-4.2.1-alpha.0" = "sha256-a2A2rKll2RTSyvohqRUSQ4Sw6puJdlTZoof5rePxPVE=";
      "spd-0.1.0" = "sha256-X6XUx+huQp77XF5EZDYYqRqaHsdDSbDMK8qcuSGob3E=";
      "tlvc-0.1.0" = "sha256-SKaVDKFUveZ/iSbKUrVbFIbni7HxCZG4P7fZxkBxY1k=";
      "tlvc-text-0.1.0" = "sha256-uHPPyc3Ns5L1/EFNCzH8eBEoqLlJoqguZxwNCNxfM6Q=";
      "vsc7448-info-0.1.0" = "sha256-otNLdfGIzuyu03wEb7tzhZVVMdS0of2sU/AKSNSsoho=";
    };
  };

  meta = with lib; {
    description = "Debugger for Hubris";
    homepage = "https://github.com/oxidecomputer/humility";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ therishidesai ];
  };
}
