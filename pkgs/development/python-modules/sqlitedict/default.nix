{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  py,
  pytest-benchmark,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sqlitedict";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "sqlitedict";
    tag = "v${version}";
    hash = "sha256-GfvvkQ6a75UBPn70IFOvjvL1MedSc4siiIjA3IsQnic=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    py
    pytest-benchmark
    pytestCheckHook
  ];

  preCheck = ''
    mkdir tests/db
  '';

  pythonImportsCheck = [ "sqlitedict" ];

  pytestFlags = [ "--benchmark-disable" ];

  meta = {
    description = "Persistent, thread-safe dict";
    homepage = "https://github.com/RaRe-Technologies/sqlitedict";
    changelog = "https://github.com/piskvorky/sqlitedict/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arnoldfarkas ];
  };
}
