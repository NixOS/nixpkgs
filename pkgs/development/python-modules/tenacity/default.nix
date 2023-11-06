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
  version = "8.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U5jvDXjmP0AAfB+0wL/5bhkROU0vqNGU93YZwF/2zIo=";
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
