{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, numba
, numpy
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "timezonefinder";
  version = "5.2.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a374570295a8dbd923630ce85f754e52578e288cb0a9cf575834415e84758352";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [ numba pytestCheckHook pytest-cov ];

  meta = with lib; {
    description = "fast python package for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    license = licenses.mit;
  };
}
