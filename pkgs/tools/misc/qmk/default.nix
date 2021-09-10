{ lib, python3, fetchpatch, writeText }:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
  setuppy = writeText "setup.py" ''
    from setuptools import setup
    setup()
  '';
in buildPythonApplication rec {
  pname = "qmk";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2mLuxzxFSMw3sLm+OTcgLcOjAdwvJmNhDsynUaYQ+co=";
  };

  nativeBuildInputs = with python3.pkgs; [
    flake8
    nose2
    pep8-naming
    setuptools-scm
    yapf
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    argcomplete
    colorama
    qmk-dotty-dict
    hid
    hjson
    jsonschema
    milc
    pygments
    pyusb
  ];

  postConfigure = ''
    cp ${setuppy} setup.py
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
    maintainers = with maintainers; [ bhipple babariviere ];
  };
}
