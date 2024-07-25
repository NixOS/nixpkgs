{
  lib,
  buildPythonPackage,
  fetchPypi,
  flaky,
  numpy,
  packaging,
  pandas,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "2024.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-C5HgvE3AKWlHlHZA/jHsboZ84ljS98vBC+30ptaDQMc=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    packaging
    pandas
  ];

  nativeCheckInputs = [
    flaky
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # ModuleNotFoundError: No module named 'xarray.datatree_'
    "--ignore xarray/tests/datatree"
  ];

  pythonImportsCheck = [ "xarray" ];

  meta = with lib; {
    description = "N-D labeled arrays and datasets in Python";
    homepage = "https://github.com/pydata/xarray";
    license = licenses.asl20;
  };
}
