{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "wazeroutecalculator";
  version = "0.15";
  format = "setuptools";

  src = fetchPypi {
    pname = "WazeRouteCalculator";
    inherit version;
    hash = "sha256-DB5oWthWNwamFG3kNxA/kmUBOVogoSg5LI2KrI39s4M=";
  };

  propagatedBuildInputs = [ requests ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "WazeRouteCalculator" ];

  meta = {
    description = "Calculate actual route time and distance with Waze API";
    homepage = "https://github.com/kovacsbalu/WazeRouteCalculator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
