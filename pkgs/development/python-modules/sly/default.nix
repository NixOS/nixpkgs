{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sly";
  version = "0.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0an31bm5m8wqwphanmcsbbnmycy6l4xkmg4za4bwq8hk4dm2dwp5";
  };

  checkInputs = [ pytest ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "An improved PLY implementation of lex and yacc for Python 3";
    homepage = "https://github.com/dabeaz/sly";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
