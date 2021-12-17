{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "wazeroutecalculator";
  version = "0.13";

  src = fetchPypi {
    pname = "WazeRouteCalculator";
    inherit version;
    sha256 = "sha256-Ex9yglaJkk0+Uo3Y+xpimb5boXz+4QdbJS2O75U6dUg=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "WazeRouteCalculator" ];

  meta = with lib; {
    description = "Calculate actual route time and distance with Waze API";
    homepage = "https://github.com/kovacsbalu/WazeRouteCalculator";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
