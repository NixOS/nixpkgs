{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fastuuid,
  fetchPypi,
  httpx,
  importlib-metadata,
  jinja2,
  jsonschema,
  nix-update-script,
  openai,
  pydantic,
  python-dotenv,
  setuptools,
  tiktoken,
  tokenizers,
}:

buildPythonPackage (finalAttrs: {
  pname = "unclecode-litellm";
  version = "1.81.13";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "unclecode_litellm";
    inherit (finalAttrs) version;
    hash = "sha256-23DjTj6FnAoH8CywLqpkT4+ktOzF4vO+mli9fRw/7tw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    click
    fastuuid
    httpx
    importlib-metadata
    jinja2
    jsonschema
    openai
    pydantic
    python-dotenv
    tiktoken
    tokenizers
  ];

  # tests require access network
  doCheck = false;

  pythonImportsCheck = [ "litellm" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pre-compromise fork of litellm to interface with LLM API providers";
    homepage = "https://pypi.org/project/unclecode-litellm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
