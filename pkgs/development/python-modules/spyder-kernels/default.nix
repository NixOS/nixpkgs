{
  lib,
  buildPythonPackage,
  setuptools,
  cloudpickle,
  fetchPypi,
  ipykernel,
  ipython,
  jupyter-client,
  packaging,
  pythonOlder,
  pyxdg,
  pyzmq,
  wurlitzer,
}:

buildPythonPackage rec {
  pname = "spyder-kernels";
  version = "2.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "spyder_kernels";
    inherit version;
    hash = "sha256-cfJSkA4CsDlIIMxwSfie1yUkP2/M9kC3bdMpIDxBOWA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cloudpickle
    ipykernel
    ipython
    jupyter-client
    packaging
    pyxdg
    pyzmq
    wurlitzer
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "spyder_kernels" ];

  meta = {
    description = "Jupyter kernels for Spyder's console";
    homepage = "https://docs.spyder-ide.org/current/ipythonconsole.html";
    downloadPage = "https://github.com/spyder-ide/spyder-kernels/releases";
    changelog = "https://github.com/spyder-ide/spyder-kernels/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gebner ];
  };
}
