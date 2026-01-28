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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-extensions2";
    repo = "sphinx-pytest";
    tag = "v${version}";
    hash = "sha256-z71IrUr3e2oAPeZMjUBwMwy2SkoAA3oxtK4+iR9vLEc=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ sphinx ];

  buildInputs = [ pytest ];

  pythonImportsCheck = [ "sphinx_pytest" ];

  nativeCheckInputs = [
    defusedxml
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/sphinx-extensions2/sphinx-pytest/releases/tag/v${version}";
    description = "Helpful pytest fixtures for Sphinx extensions";
    homepage = "https://github.com/chrisjsewell/sphinx-pytest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
}
