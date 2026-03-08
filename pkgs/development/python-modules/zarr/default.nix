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
  # test
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov,
  pytest-accept ? null, # TODO: Package
  rich,
  mypy,
  numpydoc,
  hypothesis,
  pytest-xdist,
  tomlkit,
  uv,
  # remote_tests
  botocore,
  s3fs,
  moto,
  requests,
  # optional
  universal-pathlib,
  # docs
  mkdocs-material,
  mkdocs,
  mkdocstrings,
  mkdocstrings-python,
  mike,
  mkdocs-redirects,
  markdown-exec ? null, # TODO: Package
  griffe-inherited-docstrings ? null, # TODO: Package,
  ruff,
  towncrier,
  astroid,
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
      # Development extras
      test = [
        #pytest
        pytest-asyncio
        pytest-cov
        pytest-accept
        rich
        mypy
        numpydoc
        hypothesis
        # From some reason the existence of pytest-xdist makes the tests fail
        # depending on $NIX_BUILD_CORES
        #pytest-xdist
        packaging
        tomlkit
        uv
      ];
      remote_tests = [
        botocore
        s3fs
        moto
        requests
      ]
      ++ moto.optional-dependencies.server
      ++ moto.optional-dependencies.s3;
      optional = [
        rich
        universal-pathlib
      ];
      docs = [
        # Doc building
        mkdocs-material
        mkdocs
        mkdocstrings
        mkdocstrings-python
        mike
        mkdocs-redirects
        markdown-exec
        griffe-inherited-docstrings
        ruff
        towncrier # Changelog generation
        # Optional dependencies to run examples
        rich
        s3fs
        astroid
        #pytest
      ]
      ++ mkdocs-material.optional-dependencies.imaging
      ++ lib.optionals (markdown-exec != null) markdown-exec.optional-dependencies.ansi
      ++ numcodecs.optional-dependencies.msgpack;
    };
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.finalPackage.passthru.optional-dependencies.cli
  # Not adding `passthru.optional-dependencies.remote{,_tests}` since the
  # existence of these Python modules triggers tests that fail in the sandbox
  # due to failed network requests.
  ++ finalAttrs.finalPackage.passthru.optional-dependencies.test;

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
