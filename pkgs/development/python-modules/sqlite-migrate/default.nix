{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  uv-build,
  sqlite-utils,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqlite-migrate";
  version = "0.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "sqlite-migrate";
    tag = finalAttrs.version;
    hash = "sha256-0fU3yOujqc4mZS4XcsM9xH2iK9fFX5MUsmuc/o+I+nY=";
  };

  build-system = [
    setuptools
    uv-build
  ];

  propagatedBuildInputs = [ sqlite-utils ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sqlite_migrate" ];

  meta = {
    description = "Simple database migration system for SQLite, based on sqlite-utils";
    homepage = "https://github.com/simonw/sqlite-migrate";
    changelog = "https://github.com/simonw/sqlite-migrate/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
})
