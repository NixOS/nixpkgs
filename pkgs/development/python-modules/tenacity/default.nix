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
  version = "8.2.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q68DeCK9ACkCWHfzstl8xNe7DCmRAAo9WdcVF8XJaeA=";
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
