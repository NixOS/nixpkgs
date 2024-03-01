{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools-scm
, nipreps-versions
, pybids
, requests
, tqdm
}:

buildPythonPackage rec {
  pname = "templateflow";
  version = "23.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "templateflow";
    repo = "python-client";
    rev = "refs/tags/${version}";
    hash = "sha256-8AdXC1IFGfYZ5cvCAyBz0tD3zia+KBILX0tL9IcO2NA=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    nipreps-versions
    pybids
    requests
    tqdm
  ];

  doCheck = false;  # most tests try to download data
  #pythonImportsCheck = [ "templateflow" ];  # touches $HOME/.cache, hence needs https://github.com/NixOS/nixpkgs/pull/120300

  meta = with lib; {
    homepage = "https://templateflow.org/python-client";
    description = "Python API to query TemplateFlow via pyBIDS";
    changelog = "https://github.com/templateflow/python-client/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
