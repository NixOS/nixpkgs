{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tree-sitter";
  version = "0.21.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "py-tree-sitter";
    rev = "refs/tags/v${version}";
    hash = "sha256-U4ZdU0lxjZO/y0q20bG5CLKipnfpaxzV3AFR6fGS7m4=";
    fetchSubmodules = true;
  };

  patches = [
    #  Replace distutils with setuptools, https://github.com/tree-sitter/py-tree-sitter/pull/214
    (fetchpatch {
      name = "replace-distutils.patch";
      url = "https://github.com/tree-sitter/py-tree-sitter/commit/80d3cae493c4a47e49cc1d2ebab0a8eaf7617825.patch";
      hash = "sha256-00coI8/COpYMiSflAECwh6yJCMJj/ucFEn18Npj2g+Q=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tree_sitter" ];

  preCheck = ''
    rm -r tree_sitter
  '';

  meta = with lib; {
    description = "Python bindings to the Tree-sitter parsing library";
    homepage = "https://github.com/tree-sitter/py-tree-sitter";
    changelog = "https://github.com/tree-sitter/py-tree-sitter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
