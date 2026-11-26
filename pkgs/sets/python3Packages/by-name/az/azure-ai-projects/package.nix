{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  azure-core,
  azure-storage-blob,
  azure-ai-agents,
  isodate,
  typing-extensions,
  azure-cli,
}:

buildPythonPackage rec {
  pname = "azure-ai-projects";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_ai_projects";
    inherit version;
    hash = "sha256-tfAwJMzw/VQ/vg9avMdORbFezMHHGrh/xxxjBh2f1jw=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    azure-core
    azure-storage-blob
    azure-ai-agents
    isodate
    typing-extensions
  ];

  pythonImportsCheck = [
    "azure.ai.projects"
  ];

  meta = {
    description = "Microsoft Azure AI Projects Client Library for Python";
    homepage = "https://pypi.org/project/azure-ai-projects/#history";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
