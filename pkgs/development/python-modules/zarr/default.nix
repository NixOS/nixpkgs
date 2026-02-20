{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  donfig,
  numpy,
  numcodecs,
  packaging,
  typing-extensions,

  # tests
  hypothesis,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  tomlkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "zarr";
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zarr-developers";
    repo = "zarr-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/rDKfu0KTYBU2lxZAwQ7eOUw9ivgklil5Yhb5rv1uiw=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    donfig
    numcodecs
    numpy
    packaging
    typing-extensions
  ]
  ++ numcodecs.optional-dependencies.crc32c;

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    tomlkit
  ];

  disabledTestPaths = [
    # requires uv and then fails at setting up python envs
    "tests/test_examples.py::test_scripts_can_run[script_path0]"
  ];

  pythonImportsCheck = [ "zarr" ];

  meta = {
    description = "Implementation of chunked, compressed, N-dimensional arrays for Python";
    homepage = "https://github.com/zarr-developers/zarr";
    changelog = "https://github.com/zarr-developers/zarr-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
