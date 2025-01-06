{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools-scm,
  nipreps-versions,
  pybids,
  requests,
  tqdm,
}:

buildPythonPackage rec {
  pname = "templateflow";
  version = "24.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "templateflow";
    repo = "python-client";
    rev = "refs/tags/${version}";
    hash = "sha256-UxYJnKOqIIf10UW5xJ7MrFHtZY5WNVi5oZgdozj65Z8=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    nipreps-versions
    pybids
    requests
    tqdm
  ];

  doCheck = false; # most tests try to download data
  #pythonImportsCheck = [ "templateflow" ];  # touches $HOME/.cache, hence needs https://github.com/NixOS/nixpkgs/pull/120300

  meta = with lib; {
    homepage = "https://templateflow.org/python-client";
    description = "Python API to query TemplateFlow via pyBIDS";
    changelog = "https://github.com/templateflow/python-client/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
