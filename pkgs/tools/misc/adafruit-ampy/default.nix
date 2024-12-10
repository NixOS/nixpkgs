{
  lib,
  python3,
  fetchPypi,
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "adafruit-ampy";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f4cba36f564096f2aafd173f7fbabb845365cc3bb3f41c37541edf98b58d3976";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    click
    python-dotenv
    pyserial
  ];

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
