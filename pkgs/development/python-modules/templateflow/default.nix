{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  hatchling,
  hatch-vcs,
  nipreps-versions,
  pybids,
  requests,
  tqdm,
}:

buildPythonPackage rec {
  pname = "templateflow";
  version = "25.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "templateflow";
    repo = "python-client";
    tag = version;
    hash = "sha256-7N8JJAJwnmesQIoZttcphmUW5HLEi8Rxv70MGNjOO98=";
  };

  build-system = [
    setuptools-scm
    hatchling
    hatch-vcs
  ];

  dependencies = [
    nipreps-versions
    pybids
    requests
    tqdm
  ];

  doCheck = false; # most tests try to download data

  postFixup = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "templateflow" ];

  meta = {
    homepage = "https://templateflow.org/python-client";
    description = "Python API to query TemplateFlow via pyBIDS";
    changelog = "https://github.com/templateflow/python-client/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
