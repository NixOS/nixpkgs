{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, sphinx
, gcc
, cython
}:

buildPythonPackage rec {
  pname = "sphinx-automodapi";
  version = "0.14.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "astropy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-olD9LIyFCNEu287wQIRqoabfrdcdyZpNc69jq/e1304=";
  };

  propagatedBuildInputs = [ sphinx ];

  # https://github.com/astropy/sphinx-automodapi/issues/155
  doCheck = false;

  checkInputs = [
    pytestCheckHook
    gcc
    cython
  ];

  pythonImportsCheck = [ "sphinx_automodapi" ];

  meta = with lib; {
    description = "Sphinx extension for generating API documentation";
    homepage = "https://github.com/astropy/sphinx-automodapi";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
