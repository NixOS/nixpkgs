{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-docstring-description,
  hatch-vcs,
  hatchling,
  coverage,
  ipykernel,
  jupyter-client,
  pytestCheckHook,
  pytest-asyncio,
  pytest-subprocess,
  testing-common-database,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "session-info2";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "session-info2";
    tag = "v${version}";
    hash = "sha256-d56aIKKBiktOepN/SXwuSaFjSelJ9QiTcbO0OvbkNW4=";
  };

  build-system = [
    hatch-docstring-description
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    coverage
    ipykernel
    jupyter-client
    pytestCheckHook
    pytest-asyncio
    pytest-subprocess
    testing-common-database
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "session_info2"
  ];

  meta = {
    description = "Report Python session information";
    homepage = "https://session-info2.readthedocs.io";
    changelog = "https://github.com/scverse/session-info2/releases/tag/${src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
