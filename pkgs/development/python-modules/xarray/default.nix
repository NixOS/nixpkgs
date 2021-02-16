{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, numpy
, pandas
, setuptools
, isPy3k
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "0.16.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OOhDnWyRvNW3wPyjSdr44GQ6xohQyYcmLVNSbp19AeQ=";
  };

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
