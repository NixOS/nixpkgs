{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sly";
  version = "0.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be6a3825b042a9e1b6f5730fc747e6d983c917f0f002d798d0b9f86ca5c05ad9";
  };

  checkInputs = [ pytest ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "An improved PLY implementation of lex and yacc for Python 3";
    homepage = https://github.com/dabeaz/sly;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
