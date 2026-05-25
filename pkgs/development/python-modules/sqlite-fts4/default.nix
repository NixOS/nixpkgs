{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqlite-fts4";
  version = "1.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "sqlite-fts4";
    tag = version;
    hash = "sha256-Ibiows3DSnzjIUv7U9tYNVnDaecBBxjXzDqxbIlNhhU=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sqlite_fts4" ];

  meta = {
    description = "Custom Python functions for working with SQLite FTS4";
    homepage = "https://github.com/simonw/sqlite-fts4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meatcar ];
  };
}
