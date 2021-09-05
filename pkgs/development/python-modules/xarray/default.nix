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
  version = "0.19.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a365ce09127fc841ba88baa63f37ca61376ffe389a6c5e66d52f2c88c23a62b";
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
