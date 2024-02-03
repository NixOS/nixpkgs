{ lib
, buildPythonPackage
, fetchPypi
, numpy
, packaging
, pandas
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "2023.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-glxtZCAqcxpOSTIe3R6d+r9L4GgC8bjIo8AKPr/Izt8=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    packaging
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xarray"
  ];

  meta = with lib; {
    description = "N-D labeled arrays and datasets in Python";
    homepage = "https://github.com/pydata/xarray";
    license = licenses.asl20;
    maintainers = with maintainers; [ fridh ];
  };
}
