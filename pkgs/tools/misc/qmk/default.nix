{ lib
, python3
, fetchpatch
}:

let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "qmk";
  version = "0.0.52";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mNF+bRhaL6JhNbROmjYDHkKKokRIALd5FZbRt9Kg5XQ=";
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
    dotty-dict
    hid
    hjson
    jsonschema
    milc
    pygments
    pyusb
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
    maintainers = with maintainers; [ bhipple ];
  };
}
