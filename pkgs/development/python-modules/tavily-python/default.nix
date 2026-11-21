{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  tiktoken,
  httpx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tavily-python";
  version = "0.8.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tavily-ai";
    repo = "tavily-python";
    rev = "46505f119e6ac0f30d63a4dce0ed9f923705ad97";
    hash = "sha256-JKrKHFWcJtNCF9Q6vwmsIyX6myrlTxd7Ti7/x2/9Mi0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    tiktoken
    httpx
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Requires network access to api.tavily.com.
    "test_invalid_api_key"
  ];

  pythonImportsCheck = [ "tavily" ];

  meta = {
    description = "Python wrapper for the Tavily API";
    homepage = "https://github.com/tavily-ai/tavily-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sshine ];
  };
}
