{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, matchpy
, numpy
, astunparse
, typing-extensions
, black
, pytest
, pytestcov
, numba
, nbval
, python
, isPy37
}:

buildPythonPackage rec {
  pname = "uarray";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fa63ae7034833a99bc1628d3cd5501d4d00f2e6437b6cbe73f710dcf212a6bea";
  };

  doCheck = false; # currently has circular dependency module import, remove when bumping to >0.5.1
  checkInputs = [ pytest nbval pytestcov numba ];
  propagatedBuildInputs = [ matchpy numpy astunparse typing-extensions black ];

  pythonImportsCheck = [ "uarray" ];

  meta = with lib; {
    description = "Universal array library";
    homepage = "https://github.com/Quansight-Labs/uarray";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
