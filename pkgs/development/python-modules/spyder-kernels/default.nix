{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cloudpickle,
  ipykernel,
  ipython,
  jupyter-client,
  pyxdg,
  pyzmq,
  wurlitzer,

  # tests
  anyio,
  django,
  flaky,
  h5py,
  numpy,
  pandas,
  pillow,
  polars,
  pyarrow,
  pydicom,
  pytestCheckHook,
  scipy,
  writableTmpDirAsHomeHook,
  xarray,
}:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = "spyder-kernels";
    tag = "v${version}";
    hash = "sha256-HqjgeCmjQfwSVaJNWnDYHGeC81/iLzmAmnFrPhpwfLY=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "ipython"
  ];

  dependencies = [
    cloudpickle
    ipykernel
    ipython
    jupyter-client
    pyxdg
    pyzmq
    wurlitzer
  ];

  nativeCheckInputs = [
    anyio
    django
    flaky
    h5py
    numpy
    pandas
    pillow
    polars
    pyarrow
    pydicom
    pytestCheckHook
    scipy
    writableTmpDirAsHomeHook
    xarray
  ];

  disabledTests = [
    "test_umr_reload_modules"
    # OSError: Kernel failed to start
    "test_debug_namespace"
    "test_enter_debug_after_interruption"
    "test_global_message"
    "test_interrupt_long_sleep"
    "test_interrupt_short_loop"
    "test_matplotlib_inline"
    "test_multiprocessing"
    "test_np_threshold"
    "test_runfile"
  ];

  pythonImportsCheck = [ "spyder_kernels" ];

  meta = {
    description = "Jupyter kernels for Spyder's console";
    homepage = "https://docs.spyder-ide.org/current/ipythonconsole.html";
    downloadPage = "https://github.com/spyder-ide/spyder-kernels/releases";
    changelog = "https://github.com/spyder-ide/spyder-kernels/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
