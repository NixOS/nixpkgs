{ lib, python3Packages, fetchPypi }:

with python3Packages;

buildPythonApplication rec {
  pname = "nyx";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iFIUiNHJBS5Fe55mSYpKz6qjrfOtxaGZiSYy8SmlOQs=";
  };

  propagatedBuildInputs = [ stem ];

  # ./run_tests.py returns `TypeError: testFailure() takes exactly 1 argument`
  doCheck = false;

  meta = with lib; {
    description = "Command-line monitor for Tor";
    mainProgram = "nyx";
    homepage = "https://nyx.torproject.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ offline ];
  };
}
