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
<<<<<<< HEAD
  version = "0.3";
=======
  version = "0.2.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "session-info2";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Li7Ik7AnWiG742x01m49iEYuOBg0FFx8amv/7KTe9gE=";
=======
    hash = "sha256-fw5FG22MzxPibC9GrWZsRLnhMcuo/eBPNRggvkkz8ms=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
