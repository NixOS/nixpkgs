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
  version = "2023.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mkXhB0GES1+UjY4edotGDffpBpbRji7/LB1H9dnVAlI=";
  };

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
