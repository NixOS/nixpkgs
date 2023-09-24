{ lib
, asciitree
, buildPythonPackage
, fasteners
, fetchPypi
, numcodecs
, numpy
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "zarr";
  version = "2.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hONraVvaDs6lKvmGEnGYTLIqXIZGeZB7e5uj95toT34=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    asciitree
    numpy
    fasteners
    numcodecs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zarr"
  ];

  meta = with lib; {
    description = "An implementation of chunked, compressed, N-dimensional arrays for Python";
    homepage = "https://github.com/zarr-developers/zarr";
    changelog = "https://github.com/zarr-developers/zarr-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
