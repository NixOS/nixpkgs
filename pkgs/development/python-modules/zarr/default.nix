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
  google-crc32c,
  packaging,
  typing-extensions,

  # optional-dependencies
  # remote
  fsspec,
  obstore ? null, # TODO: Package
  # gpu
  cupy,
  # cli
  typer,
  # optional
  rich,
  universal-pathlib,

  # test
  hypothesis,
  numpydoc,
  pytest-asyncio,
  pytestCheckHook,
  tomlkit,
  uv,
}:

buildPythonPackage (finalAttrs: {
  pname = "zarr";
  version = "3.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zarr-developers";
    repo = "zarr-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1Kx8gN1JiaY4eHmwpdilvJ8+NdnzxhDvn7YZjphgtZw=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    donfig
    numcodecs
    google-crc32c
    numpy
    packaging
    typing-extensions
  ];

  passthru = {
    optional-dependencies = {
      remote = [
        fsspec
        obstore
      ];
      gpu = [
        cupy
      ];
      cli = [
        typer
      ];
      optional = [
        rich
        universal-pathlib
      ];
    };
  };

  nativeCheckInputs = [
    hypothesis
    numpydoc
    pytest-asyncio
    pytestCheckHook
    tomlkit
    uv
  ]
  ++ finalAttrs.finalPackage.passthru.optional-dependencies.cli;

  disabledTestPaths = [
    # requires uv and then fails at setting up python envs
    "tests/test_examples.py::test_scripts_can_run[script_path0]"
    # Requires zarr==2.x to generate zarr stores for the tests
    "tests/test_regression"
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
