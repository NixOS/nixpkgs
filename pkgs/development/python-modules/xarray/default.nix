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
  version = "0.18.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d2e72a228286fcf60f66e16876bd27629a1a70bf64822c565f16515c4d10284";
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
