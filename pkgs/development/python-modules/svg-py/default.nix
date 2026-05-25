{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "svg-py";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "orsinium-labs";
    repo = "svg.py";
    tag = version;
    hash = "sha256-ZbMDjo2p0DnLB5iwQ4J3NIP/zjPsBLq7vKStF9SzF9Y=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "svg" ];

  disabledTestPaths = [
    # Tests need additional files
    "tests/test_attributes.py"
  ];

  meta = {
    description = "Type-safe Python library to generate SVG files";
    homepage = "https://github.com/orsinium-labs/svg.py";
    changelog = "https://github.com/orsinium-labs/svg.py/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
