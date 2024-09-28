{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  tornado,
  typeguard,
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "8.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i8bAyKCbMebK0TxHr77RpWdRglCpoXFBhYLtjZwgyng=";
  };

  build-system = [
    pbr
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    tornado
    typeguard
  ];

  pythonImportsCheck = [ "tenacity" ];

  meta = with lib; {
    description = "Retrying library for Python";
    homepage = "https://github.com/jd/tenacity";
    changelog = "https://github.com/jd/tenacity/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
