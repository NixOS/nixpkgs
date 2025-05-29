{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "jd";
    repo = "tenacity";
    tag = version;
    hash = "sha256-RmoW3gwblwoM4L9QTuc/7gLJJOSxMUYv7FmWxdf/KxE=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    tornado
    typeguard
  ];

  pythonImportsCheck = [ "tenacity" ];

  meta = {
    homepage = "https://github.com/jd/tenacity";
    changelog = "https://github.com/jd/tenacity/releases/tag/${version}";
    description = "Retrying library for Python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jakewaksbaum ];
  };
}
