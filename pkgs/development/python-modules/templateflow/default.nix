{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  version = "25.0.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "templateflow";
    repo = "python-client";
    tag = version;
    hash = "sha256-5LGAuDaJzc2asM5EPOVuOxZwpV0LQNBhMhYKHJlXHmE=";
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

  meta = with lib; {
    homepage = "https://templateflow.org/python-client";
    description = "Python API to query TemplateFlow via pyBIDS";
    changelog = "https://github.com/templateflow/python-client/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
