{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "wazeroutecalculator";
  version = "0.15";

  src = fetchPypi {
    pname = "WazeRouteCalculator";
    inherit version;
    sha256 = "0c1e685ad8563706a6146de437103f926501395a20a128392c8d8aac8dfdb383";
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
