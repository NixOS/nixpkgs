{
  lib,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  flatbuffers,
  h3,
  numba,
  numpy,
  pydantic,
  pytestCheckHook,
  pytz,
  setuptools,
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

  build-system = [ setuptools ];

  nativeBuildInputs = [ cffi ];

  dependencies = [
    cffi
    flatbuffers
    h3
    numpy
  ];

  optional-dependencies = {
    numba = [ numba ];
    pytz = [ pytz ];
  };

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

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

  meta = with lib; {
    description = "Module for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    changelog = "https://github.com/jannikmi/timezonefinder/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "timezonefinder";
  };
}
