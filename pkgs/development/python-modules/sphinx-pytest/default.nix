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
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "chrisjsewell";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-26cV6mfNos/1YLhz5aVQVb54qsiyHWdcHtvmmSzMurk=";
  };

  format = "pyproject";

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    sphinx
  ];

  buildInputs = [
    pytest
  ];

  pythonImportsCheck = [ "sphinx_pytest" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Helpful pytest fixtures for Sphinx extensions";
    homepage = "https://github.com/chrisjsewell/sphinx-pytest";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
  };
}
