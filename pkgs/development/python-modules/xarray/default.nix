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
  version = "0.20.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c0bffd8b55fdef277f8f6c817153eb51fa4e58653a7ad92eaed9984164b7bdb";
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
