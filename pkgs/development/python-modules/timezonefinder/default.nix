{ buildPythonPackage
, lib
, fetchPypi
, importlib-resources
, numba
, numpy
}:

buildPythonPackage rec {
  pname = "timezonefinder";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18wn6k9is4kh5ijglmvb7g0xxpjxf8qdr4kddbzw1ra30f55as85";
  };

  propagatedBuildInputs = [
    importlib-resources
    numpy
  ];

  checkInputs = [ numba ];

  meta = with lib; {
    description = "fast python package for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    license = licenses.mit;
  };
}
