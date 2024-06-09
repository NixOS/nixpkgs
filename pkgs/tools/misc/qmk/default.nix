{ lib
, python3
, fetchPypi
, pkgsCross
, avrdude
, dfu-programmer
, dfu-util
, wb32-dfu-updater
, gcc-arm-embedded
, gnumake
, teensy-loader-cli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "qmk";
  version = "1.1.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Lv48dSIwxrokuHGcO26FpWRL+PfQ3SN3V+2pt7fmCxE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dotty-dict
    hid
    hjson
    jsonschema
    milc
    pygments
    pyserial
    pyusb
    pillow
  ] ++ [ # Binaries need to be in the path so this is in propagatedBuildInputs
    avrdude
    dfu-programmer
    dfu-util
    wb32-dfu-updater
    teensy-loader-cli
    gcc-arm-embedded
    gnumake
    pkgsCross.avr.buildPackages.binutils
    pkgsCross.avr.buildPackages.binutils.bintools
    pkgsCross.avr.buildPackages.gcc8
    pkgsCross.avr.libcCross
  ];

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/qmk/qmk_cli";
    description = "A program to help users work with QMK Firmware";
    longDescription = ''
      qmk_cli is a companion tool to QMK firmware. With it, you can:

      - Interact with your qmk_firmware tree from any location
      - Use qmk clone to pull down anyone's qmk_firmware fork
      - Setup and work with your build environment:
        - qmk setup
        - qmk doctor
        - qmk compile
        - qmk console
        - qmk flash
        - qmk lint
      - ... and many more!
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ekleog ];
    mainProgram = "qmk";
  };
}
