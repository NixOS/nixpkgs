{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, numba
, numpy
, pytestCheckHook
, pytestcov
}:

buildPythonPackage rec {
  pname = "timezonefinder";
  version = "4.5.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "99b0cea5abf304e8738ecf5cceae0c0e5182534843f19638a26a220fa212fbad";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [ numba pytestCheckHook pytestcov ];

  meta = with lib; {
    description = "fast python package for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    license = licenses.mit;
  };
}
