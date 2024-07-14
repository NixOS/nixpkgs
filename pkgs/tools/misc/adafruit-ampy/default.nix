{ lib, python3, fetchPypi }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "adafruit-ampy";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9Mujb1ZAlvKq/Rc/f7q7hFNlzDuz9Bw3VB7fmLWNOXY=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ click python-dotenv pyserial ];

  # No tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pycampers/ampy";
    license = licenses.mit;
    description = "Utility to interact with a MicroPython board over a serial connection";
    maintainers = with maintainers; [ ];
    mainProgram = "ampy";
  };
}
