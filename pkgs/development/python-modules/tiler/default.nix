{
  lib,
  buildPythonPackage,
  fetchpatch,
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

  patches = [
    # https://github.com/the-lay/tiler/pull/24
    (fetchpatch {
      name = "unpin-setuptools-scm-dependency.patch";
      url = "https://github.com/the-lay/tiler/commit/7a9f7e32c5f9c263c1ae28bfd19c7539556684cb.patch";
      hash = "sha256-TMr3LJtiKUxJv2pAzAd8CWs3AtWsF0YS79NzKBN5TKM=";
    })
  ];

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
