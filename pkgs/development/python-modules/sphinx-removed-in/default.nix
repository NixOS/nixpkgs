{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  sphinx,
  defusedxml,
}:

buildPythonPackage rec {
  pname = "sphinx-removed-in";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MrSenko";
    repo = "sphinx-removed-in";
    rev = "refs/tags/v${version}";
    hash = "sha256-ygcKDWf7DDoOjTEio633/9O8RdKZo9CkU3yJPKWsVu8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sphinx
    defusedxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sphinx_removed_in" ];

  meta = {
    description = "versionremoved and removed-in directives for Sphinx";
    homepage = "https://github.com/MrSenko/sphinx-removed-in";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
