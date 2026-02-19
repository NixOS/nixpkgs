{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  redis,
  redisTestHook,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "walrus";
  version = "0.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = "walrus";
    tag = finalAttrs.version;
    hash = "sha256-AgaqDZHjUX/oLjzisWjZcrGL9QXQf73WW+hfK2WMQJ8=";
  };

  build-system = [ setuptools ];

  dependencies = [ redis ];

  nativeCheckInputs = [
    unittestCheckHook
    redisTestHook
  ];

  pythonImportsCheck = [ "walrus" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Lightweight Python utilities for working with Redis";
    homepage = "https://github.com/coleifer/walrus";
    changelog = "https://github.com/coleifer/walrus/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
