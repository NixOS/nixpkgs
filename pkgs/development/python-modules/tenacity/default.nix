{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  tornado,
  typeguard,
}:

buildPythonPackage rec {
  pname = "tenacity";
  version = "9.1.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EWnTdsKX5944jRi0SBdg1Hiw6Zp3fK06nIblVvS2l8s=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    tornado
    typeguard
  ];

  pythonImportsCheck = [ "tenacity" ];

  meta = with lib; {
    homepage = "https://github.com/jd/tenacity";
    changelog = "https://github.com/jd/tenacity/releases/tag/${version}";
    description = "Retrying library for Python";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
