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
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0j2pin54pwm1vdgza8irxcjb2za7h41c0ils04afssdn59cixslx";
  };

  doCheck = false; # currently has circular dependency module import, remove when bumping to >0.5.1
  checkInputs = [ pytest nbval pytestcov numba ];
  propagatedBuildInputs = [ matchpy numpy astunparse typing-extensions black ];

  pythonImportsCheck = [ "uarray" ];

  meta = with lib; {
    description = "Universal array library";
    homepage = https://github.com/Quansight-Labs/uarray;
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
