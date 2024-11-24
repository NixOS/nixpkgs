{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  rpm,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "specfile";
  version = "0.32.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "packit";
    repo = "specfile";
    rev = version;
    hash = "sha256-rUrXlr0277r4XiOiNmq3FBfOKWZGVUSf+S8MBmUfl+8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ rpm ];
  pythonImportsCheck = [
    "specfile"
    "rpm"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A library for parsing and manipulating RPM spec files";
    homepage = "https://packit.dev/specfile";
    changelog = "https://github.com/packit/specfile/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sielicki ];
  };
}
