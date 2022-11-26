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
  version = "2.13.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2ySwkGFsY49l4zprxdlW1kIiEYKWFRXMvCixf7DQtIw=";
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

  # Core dump looks like caused by numpy
  doCheck = false;

  # checkInputs = [
  #   pytestCheckHook
  # ];

  # pythonImportsCheck = [
  #   "zarr"
  # ];

  meta = with lib; {
    description = "Implementation of chunked, compressed, N-dimensional arrays";
    homepage = "https://github.com/zarr-developers/zarr";
    changelog = "https://github.com/zarr-developers/zarr-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
