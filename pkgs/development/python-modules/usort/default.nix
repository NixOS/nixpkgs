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
  stdlibs,
  toml,
  trailrunner,
  unittestCheckHook,
  volatile,
}:

buildPythonPackage rec {
  pname = "usort";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "usort";
    tag = "v${version}";
    hash = "sha256-QnhpnuEt6j/QPmX29A0523QDh4o2QfaCoDI0YJpTc8Y=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
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
    homepage = "https://github.com/facebook/usort";
    changelog = "https://github.com/facebook/usort/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "usort";
  };
}
