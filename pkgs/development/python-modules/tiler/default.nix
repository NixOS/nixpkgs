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
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ps0uHgzPa+ZoXXrB+0gfuVIEBUNmym/ym6xCxiyHhxA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tiler" ];

  meta = with lib; {
    description = "N-dimensional NumPy array tiling and merging with overlapping, padding and tapering";
    homepage = "https://the-lay.github.io/tiler/";
    license = licenses.mit;
    maintainers = with maintainers; [ atila ];
  };
}
