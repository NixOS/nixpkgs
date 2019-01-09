{ lib
, buildPythonPackage
, fetchPypi
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
  version = "0.4";
  format = "flit";
  # will have support soon see
  # https://github.com/Quansight-Labs/uarray/pull/64
  disabled = isPy37;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ec88f477d803a914d58fdf83aeedfb1986305355775cf55525348c62cce9aa4";
  };

  checkInputs = [ pytest nbval pytestcov numba ];
  propagatedBuildInputs = [ matchpy numpy astunparse typing-extensions black ];

  checkPhase = ''
    ${python.interpreter} extract_readme_tests.py
    pytest
  '';

  meta = with lib; {
    description = "Universal array library";
    homepage = https://github.com/Quansight-Labs/uarray;
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
