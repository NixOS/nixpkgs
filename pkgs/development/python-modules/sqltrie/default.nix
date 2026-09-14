{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pygtrie,
  pyinstaller,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqltrie";
  version = "0.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "sqltrie";
    tag = finalAttrs.version;
    hash = "sha256-sBu82SDOBqlQLONYgQ4eCw6MVFsLIs5/LfevP4cUDTo=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    orjson
    pygtrie
  ];

  nativeCheckInputs = [
    pyinstaller
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sqltrie" ];

  disabledTestPaths = [
    # Ignoring benchmark tests
    "tests/benchmarks/test_sqltrie.py"
  ];

  meta = {
    description = "DVC's data management subsystem";
    homepage = "https://github.com/iterative/sqltrie";
    changelog = "https://github.com/iterative/sqltrie/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
