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
  version = "1.4.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "orsinium-labs";
    repo = "svg.py";
    rev = "refs/tags/${version}";
    hash = "sha256-rnxznJM3ihuEJrD3ba6uMdGMozIrLw/QyGzA3JPygH4=";
  };

  nativeBuildInputs = [ flit-core ];

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
    changelog = "https://github.com/orsinium-labs/svg.py/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
