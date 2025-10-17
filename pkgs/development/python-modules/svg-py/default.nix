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
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "orsinium-labs";
    repo = "svg.py";
    tag = version;
    hash = "sha256-ILnPviXUHJrdeT6VTUYAZog3zY0tVA+13ddf8yVRYqE=";
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
