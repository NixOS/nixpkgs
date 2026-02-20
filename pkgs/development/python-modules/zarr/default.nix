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

  # optional-dependencies
  # remote
  fsspec,
  obstore ? null, # TODO: Package
  # gpu
  cupy,
  # test
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov,
  pytest-accept ? null, # TODO: Package
  rich,
  mypy,
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
  sphinx,
  sphinx-autobuild,
  sphinx-autoapi,
  sphinx-design,
  sphinx-issues,
  sphinx-copybutton,
  sphinx-reredirects,
  pydata-sphinx-theme,
  numpydoc,
  towncrier,
  astroid,
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

  passthru = {
    optional-dependencies = {
      remote = [
        fsspec
        obstore
      ];
      gpu = [
        cupy
      ];
      # Development extras
      test = [
        #pytest
        pytest-asyncio
        pytest-cov
        pytest-accept
        rich
        mypy
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
        sphinx
        sphinx-autobuild
        sphinx-autoapi
        sphinx-design
        sphinx-issues
        sphinx-copybutton
        sphinx-reredirects
        pydata-sphinx-theme
        numpydoc
        towncrier # Changelog generation
        # Optional dependencies to run examples
        rich
        s3fs
        astroid
        #pytest
      ]
      ++ numcodecs.optional-dependencies.msgpack;
    };
  };

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
