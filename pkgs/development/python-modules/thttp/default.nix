{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "thttp";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sesh";
    repo = "thttp";
    tag = version;
    hash = "sha256-e15QMRMpTcWo8TfH3tk23ybSlXFb8F4B/eqAp9oyK8g=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "thttp" ];

  meta = {
    description = "Lightweight wrapper around urllib";
    homepage = "https://github.com/sesh/thttp";
    changelog = "https://github.com/sesh/thttp/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
