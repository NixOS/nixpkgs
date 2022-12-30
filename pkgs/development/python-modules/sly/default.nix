{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sly";
  version = "0.5";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JR1CAV6FBxWK7CFk8GA130qCsDFM5kUPRX1xJedkkCQ=";
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
