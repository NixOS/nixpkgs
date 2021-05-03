{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, numpy
, pandas
, setuptools
, isPy3k
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "0.17.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c2edad2a4e588f9117c666a4249920b9717fb75703b96998cf65fcd4f60551f";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ numpy pandas setuptools ];
  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xarray" ];

  meta = {
    description = "N-D labeled arrays and datasets in Python";
    homepage = "https://github.com/pydata/xarray";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
