{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, setuptools
, setuptoolsBuildHook
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "0.20.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wuvoDKgbEKAkH2h23MNKyWluXFzc30dY2nz0vXMsQfc=";
  };

  nativeBuildInputs = [
    setuptoolsBuildHook
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    setuptools
  ];

  checkInputs = [
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
