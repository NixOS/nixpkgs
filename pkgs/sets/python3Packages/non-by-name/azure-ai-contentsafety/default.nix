{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  azure-core,
  isodate,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-ai-contentsafety";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    tag = "azure-ai-contentsafety_${finalAttrs.version}";
    hash = "sha256-g3QI3D0bLpUl6CvcuU/5cact9598GGZQuPs73k9ZtQw=";
  };

  sourceRoot = "${finalAttrs.src.name}/sdk/contentsafety/azure-ai-contentsafety";

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    isodate
  ];

  pythonImportsCheck = [ "azure.ai.contentsafety" ];

  # tests need devtools_testutils from azure-sdk-for-python
  doCheck = false;

  meta = {
    description = "Microsoft Azure AI Content Safety client library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/contentsafety/azure-ai-contentsafety";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/${finalAttrs.src.tag}/sdk/contentsafety/azure-ai-contentsafety/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anish ];
  };
})
