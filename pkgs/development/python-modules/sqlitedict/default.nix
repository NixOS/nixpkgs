{ lib
, buildPythonPackage
, fetchFromGitHub
, py
, pytest-benchmark
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "sqlitedict";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "sqlitedict";
    rev = "refs/tags/v${version}";
    hash = "sha256-GfvvkQ6a75UBPn70IFOvjvL1MedSc4siiIjA3IsQnic=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    py
    pytest-benchmark
    pytestCheckHook
  ];

  preCheck = ''
    mkdir tests/db
  '';

  pythonImportsCheck = [
    "sqlitedict"
  ];

  pytestFlagsArray = [
    "--benchmark-disable"
  ];

  meta = with lib; {
    description = "Persistent, thread-safe dict";
    homepage = "https://github.com/RaRe-Technologies/sqlitedict";
    changelog = "https://github.com/piskvorky/sqlitedict/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnoldfarkas ];
  };
}
