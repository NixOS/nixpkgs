{ lib
, buildPythonPackage
, fetchPypi
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wazeroutecalculator";
  version = "0.15";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "WazeRouteCalculator";
    inherit version;
    sha256 = "sha256-DB5oWthWNwamFG3kNxA/kmUBOVogoSg5LI2KrI39s4M=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [
    "WazeRouteCalculator"
  ];

  meta = with lib; {
    description = "Calculate actual route time and distance with Waze API";
    homepage = "https://github.com/kovacsbalu/WazeRouteCalculator";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
