{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "svg-py";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "orsinium-labs";
    repo = "svg.py";
    tag = version;
    hash = "sha256-WRPHNgaKjim91pLdM8iQ1/1DBm7+lU7hFH0vXTguG1s=";
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

  meta = with lib; {
    description = "Type-safe Python library to generate SVG files";
    homepage = "https://github.com/orsinium-labs/svg.py";
    changelog = "https://github.com/orsinium-labs/svg.py/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
