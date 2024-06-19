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
  version = "8.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VLFBK4eN334fFXfNSVJ7rYze8yQhvVmb6sDGw/EFgv0=";
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

  pythonImportsCheck = [ "tenacity" ];

  meta = with lib; {
    homepage = "https://github.com/jd/tenacity";
    description = "Retrying library for Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
