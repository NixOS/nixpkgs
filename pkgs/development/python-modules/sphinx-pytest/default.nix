{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytest
, sphinx
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sphinx-pytest";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "chrisjsewell";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vRHPq6BAuhn5QvHG2BGen9v6ezA3RgFVtustsNxU+n8=";
  };

  format = "flit";

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    sphinx
  ];

  buildInputs = [
    pytest
  ];

  pythonImportsCheck = [ "sphinx_pytest" ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Helpful pytest fixtures for Sphinx extensions";
    homepage = "https://github.com/chrisjsewell/sphinx-pytest";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
  };
}
