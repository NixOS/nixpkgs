{ lib
, buildPythonPackage
, fetchPypi
, numpy
, packaging
, pandas
, pytestCheckHook
, pythonOlder
, setuptoolsBuildHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "2022.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CD0I5VKnZHx+zhNt+jpLahN5JWvrVbvti43fBfHhTsc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION="${version}";

  nativeBuildInputs = [
    setuptoolsBuildHook
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    packaging
    pandas
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
