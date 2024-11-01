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
  version = "9.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gH83ypfWKqNhJk1Jew4x6SuAJwRJQr+nVhYNkIMg1zs=";
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
