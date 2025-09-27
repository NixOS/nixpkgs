{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
}:

buildPythonPackage rec {
  pname = "tree-sitter";
  version = "0.25.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/kPBWFVdpGcjsotS4FitREGVr9HbPKdyDFmiVFROnCA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "tree_sitter" ];

  meta = {
    description = "Python bindings to the Tree-sitter parsing library";
    homepage = "https://github.com/tree-sitter/py-tree-sitter";
    changelog = "https://github.com/tree-sitter/py-tree-sitter/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
