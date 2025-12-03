{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  numpy,
  tqdm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tiler";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ps0uHgzPa+ZoXXrB+0gfuVIEBUNmym/ym6xCxiyHhxA=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    numpy
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tiler" ];

  meta = {
    description = "N-dimensional NumPy array tiling and merging with overlapping, padding and tapering";
    homepage = "https://the-lay.github.io/tiler/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ atila ];
  };
}
