{ buildPythonPackage
, lib
, fetchPypi
, isPy27
, numba
, numpy
}:

buildPythonPackage rec {
  pname = "timezonefinder";
  version = "4.2.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q8nd279labn03dz17s4xrglk1d31q9y8wcx99l51i5cxx53zsap";
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
