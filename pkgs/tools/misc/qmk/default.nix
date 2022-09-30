{ lib
, python3
, pkgsCross
, avrdude
, dfu-programmer
, dfu-util
, gcc-arm-embedded
, gnumake
, teensy-loader-cli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "qmk";
  version = "1.1.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-3QKOCevNYfi9+MuCkp36/A4AfZelo4A7RYGbRkF3Mmk=";
  };

  nativeBuildInputs = with python3.pkgs; [
    nose2
    setuptools-scm
    yapf
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    argcomplete
    colorama
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
    teensy-loader-cli
    gcc-arm-embedded
    gnumake
    pkgsCross.avr.buildPackages.binutils
    pkgsCross.avr.buildPackages.binutils.bintools
    pkgsCross.avr.buildPackages.gcc8
    pkgsCross.avr.libcCross
  ];

  # buildPythonApplication requires setup.py; the setup.py file crafted below
  # acts as a wrapper to setup.cfg
  postConfigure = ''
    touch setup.py
    echo "from setuptools import setup" >> setup.py
    echo "setup()" >> setup.py
  '';

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
    maintainers = with maintainers; [ bhipple babariviere ekleog ];
  };
}
