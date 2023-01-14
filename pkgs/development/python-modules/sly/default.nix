{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sly";
  version = "0.5";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JR1CAV6FBxWK7CFk8GA130qCsDFM5kUPRX1xJedkkCQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  postPatch = ''
    # imperative dev dependency installation
    rm Makefile
  '';

  pythonImportsCheck = [
    "sly"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "An improved PLY implementation of lex and yacc for Python 3";
    homepage = "https://github.com/dabeaz/sly";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
