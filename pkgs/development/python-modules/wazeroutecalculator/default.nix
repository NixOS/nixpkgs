{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "wazeroutecalculator";
  version = "0.14";

  src = fetchPypi {
    pname = "WazeRouteCalculator";
    inherit version;
    sha256 = "01a6e8d7d896279fd342fd7fcb86c2b9bf97503d95e8b1a926867d504c4836ab";
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
