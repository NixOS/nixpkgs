{ lib
, buildPythonPackage
, fetchPypi
, pbr
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools-scm
, tornado
, typeguard
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "8.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5IxDf9+TQPVma5LNeZDpa8X8lV4SmLr0qQfjlyBnpEU=";
  };

  nativeBuildInputs = [
    pbr
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    tornado
    typeguard
  ];

  pythonImportsCheck = [
    "tenacity"
  ];

  meta = with lib; {
    homepage = "https://github.com/jd/tenacity";
    description = "Retrying library for Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
