{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, numba
, numpy
}:

buildPythonPackage rec {
  pname = "timezonefinder";
  version = "4.4.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ccb7ee58f5da4b05eae2154eb615eb791487d3cfeaa2a690877737a898580a9e";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [ numba ];

  meta = with lib; {
    description = "fast python package for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    license = licenses.mit;
  };
}
