{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  setuptools,
  cffi,
  flatbuffers,
  h3,
  numpy,
  numba,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "timezonefinder";
  version = "8.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jannikmi";
    repo = "timezonefinder";
    tag = version;
    hash = "sha256-jIsS8RcbMNhj5Z/AYbNyVsbQOozbk75tXSLRqhez9Ug=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  nativeBuildInputs = [ cffi ];

  dependencies = [
    cffi
    flatbuffers
    h3
    numpy
  ];

  nativeCheckInputs = [
    numba
    pydantic
    pytestCheckHook
  ];

  pythonImportsCheck = [ "timezonefinder" ];

  preCheck = ''
    # Some tests need the CLI on the PATH
    export PATH=$out/bin:$PATH
  '';

  disabledTestPaths = [
    # Don't test the archive content
    "tests/test_package_contents.py"
    "tests/test_integration.py"
    # Don't test the example
    "tests/test_example_scripts.py"
    # Tests require clang extension
    "tests/utils_test.py"
  ];

  meta = {
    description = "Find the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    changelog = "https://github.com/jannikmi/timezonefinder/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "timezonefinder";
  };
}
