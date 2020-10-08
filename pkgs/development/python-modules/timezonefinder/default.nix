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
  version = "4.4.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c84e0f4b501419349e67972d25c535d9b5fd6c100c319747049b67812a4c6b97";
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
