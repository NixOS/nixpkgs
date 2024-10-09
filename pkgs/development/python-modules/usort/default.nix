{
  lib,
  attrs,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  libcst,
  moreorless,
  pythonOlder,
  stdlibs,
  toml,
  trailrunner,
  unittestCheckHook,
  volatile,
}:

buildPythonPackage rec {
  pname = "usort";
  version = "1.0.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "usort";
    rev = "refs/tags/v${version}";
    hash = "sha256-iezq2K+Rw0djyOoFm7tguw/vkkDSyrPZIfZPmaZvFpM=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    click
    libcst
    moreorless
    stdlibs
    toml
    trailrunner
  ];

  nativeCheckInputs = [
    unittestCheckHook
    volatile
  ];

  pythonImportsCheck = [ "usort" ];

  meta = with lib; {
    description = "Safe, minimal import sorting for Python projects";
    mainProgram = "usort";
    homepage = "https://github.com/facebook/usort";
    changelog = "https://github.com/facebook/usort/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
