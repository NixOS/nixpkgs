{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytest,
  sphinx,
  defusedxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-pytest";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisjsewell";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-oSBBt+hSMs4mvGqibQHoYHXr2j/bpsGOnIMfwfTfWKQ=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ sphinx ];

  buildInputs = [ pytest ];

  pythonImportsCheck = [ "sphinx_pytest" ];

  nativeCheckInputs = [
    defusedxml
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/sphinx-extensions2/sphinx-pytest/releases/tag/v${version}";
    description = "Helpful pytest fixtures for Sphinx extensions";
    homepage = "https://github.com/chrisjsewell/sphinx-pytest";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
  };
}
