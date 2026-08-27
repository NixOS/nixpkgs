{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  tiktoken,
  httpx,
}:

buildPythonPackage rec {
  pname = "tavily-python";
  version = "0.3.5";
  pyproject = true;

  src = fetchPypi {
    pname = "tavily_python";
    inherit version;
    hash = "sha256-QV226Y2fA/CHnDO9PQ09dm8sEzP8dVn9zoLMhRSnEns=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    tiktoken
    httpx
  ];

  # Tests require API keys
  doCheck = false;

  pythonImportsCheck = [ "tavily" ];

  meta = {
    description = "Python wrapper for the Tavily AI search API";
    homepage = "https://github.com/tavily-ai/tavily-python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
