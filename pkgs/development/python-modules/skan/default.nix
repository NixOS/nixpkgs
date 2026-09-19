{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  imageio,
  matplotlib,
  networkx,
  numba,
  numpy,
  openpyxl,
  pandas,
  scikit-image,
  scipy,
  toolz,
  tqdm,

  # tests
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "skan";
  version = "0.13.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jni";
    repo = "skan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RhY46LeELnAH+s2/j8yF3ifNeOFqdwS0l5JYqtlRvBc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  dependencies = [
    imageio
    matplotlib
    networkx
    numba
    numpy
    openpyxl
    pandas
    scikit-image
    scipy
    toolz
    tqdm
  ];

  pythonImportsCheck = [ "skan" ];

  disabledTestPaths = [
    # Requires the Napari Qt GUI test stack, which needs a display server.
    "src/skan/test/test_napari_plugin.py"
  ];

  meta = {
    changelog = "https://github.com/jni/skan/releases/tag/${finalAttrs.src.tag}";
    description = "Python module to analyse skeleton (thin object) images";
    homepage = "https://skeleton-analysis.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rdk31 ];
  };
})
