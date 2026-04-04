{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,
  setuptools-scm,

  writableTmpDirAsHomeHook,

  # dependenices
  nipreps-versions,
  platformdirs,
  pybids,
  requests,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "templateflow";
  version = "25.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "templateflow";
    repo = "python-client";
    tag = finalAttrs.version;
    hash = "sha256-fpmpTvA0Q6VvXkTlALbzZl+fy4oJmnUF/WYzr2CFkFg=";
  };

  build-system = [
    hatch-vcs
    hatchling
    setuptools-scm
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  dependencies = [
    nipreps-versions
    platformdirs
    pybids
    requests
    tqdm
  ];

  doCheck = false; # most tests try to download data

  pythonImportsCheck = [ "templateflow" ];

  meta = {
    homepage = "https://templateflow.org/python-client";
    description = "Python API to query TemplateFlow via pyBIDS";
    changelog = "https://github.com/templateflow/python-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
