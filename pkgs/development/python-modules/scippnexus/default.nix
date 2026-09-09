{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  h5py,
  scipp,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "scippnexus";
  version = "26.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "scippnexus";
    tag = finalAttrs.version;
    hash = "sha256-sff/LZFoNOcmoVeQkuHZNGPZS9RMV8QrXIlmJiFJCeI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    h5py
    scipp
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "scippnexus"
  ];

  meta = {
    description = "H5py-like utility for NeXus files with seamless scipp integration";
    homepage = "https://scipp.github.io/scippnexus/";
    changelog = "https://github.com/scipp/scippnexus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
