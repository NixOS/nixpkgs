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

buildPythonPackage (finalAttrs: {
  pname = "timezonefinder";
  version = "8.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jannikmi";
    repo = "timezonefinder";
    tag = finalAttrs.version;
    hash = "sha256-OuNJ4C5/rQo8o7o8R39FvwqK7lS7IGGDjNaP2n3GTVU=";
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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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
    description = "Module for finding the timezone of any point on earth (coordinates) offline";
    homepage = "https://github.com/MrMinimal64/timezonefinder";
    changelog = "https://github.com/jannikmi/timezonefinder/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "timezonefinder";
  };
})
