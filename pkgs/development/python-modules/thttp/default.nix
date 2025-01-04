{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "thttp";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sesh";
    repo = "thttp";
    tag = version;
    hash = "sha256-e15QMRMpTcWo8TfH3tk23ybSlXFb8F4B/eqAp9oyK8g=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "thttp" ];

  meta = with lib; {
    description = "Lightweight wrapper around urllib";
    homepage = "https://github.com/sesh/thttp";
    changelog = "https://github.com/sesh/thttp/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
