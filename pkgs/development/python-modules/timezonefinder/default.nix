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
<<<<<<< HEAD
  version = "8.2.0";
=======
  version = "8.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jannikmi";
    repo = "timezonefinder";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-VIC+cLRDSaXLEz1Vpu6opoU5D0Q1xWaVq4OqzRBTiDw=";
=======
    hash = "sha256-jIsS8RcbMNhj5Z/AYbNyVsbQOozbk75tXSLRqhez9Ug=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Module for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    changelog = "https://github.com/jannikmi/timezonefinder/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    changelog = "https://github.com/jannikmi/timezonefinder/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "timezonefinder";
  };
}
