{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-generativeai,
  llama-index-core,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "llama-index-vector-stores-google";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    pname = "llama_index_vector_stores_google";
    inherit (finalAttrs) version;
    hash = "sha256-v0H/POrVPVNDXuJXSVfCJ9KhjT2uMRKCYrceLJ3PdxI=";
  };

  pythonRelaxDeps = [ "google-generativeai" ];

  build-system = [ hatchling ];

  dependencies = [
    google-generativeai
    llama-index-core
  ];

  pythonImportsCheck = [ "llama_index.vector_stores.google" ];

  meta = {
    description = "LlamaIndex Vector Store Integration for Google";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/vector_stores/llama-index-vector-stores-google";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
