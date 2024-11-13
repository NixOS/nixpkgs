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
  version = "24.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "templateflow";
    repo = "python-client";
    rev = "refs/tags/${version}";
    hash = "sha256-COS767n2aC65m6AJihZb4NhJ4ZK9YkTAZR7Hcnc/LMs=";
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
    changelog = "https://github.com/templateflow/python-client/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
