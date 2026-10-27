{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqlite-fts4";
  version = "1.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "sqlite-fts4";
    tag = finalAttrs.version;
    hash = "sha256-Ibiows3DSnzjIUv7U9tYNVnDaecBBxjXzDqxbIlNhhU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sqlite_fts4" ];

  meta = {
    description = "Custom Python functions for working with SQLite FTS4";
    homepage = "https://github.com/simonw/sqlite-fts4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meatcar ];
  };
})
