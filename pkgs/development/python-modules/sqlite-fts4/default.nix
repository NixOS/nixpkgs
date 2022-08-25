{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sqlite-fts4";
  version = "1.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Ibiows3DSnzjIUv7U9tYNVnDaecBBxjXzDqxbIlNhhU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sqlite_fts4"
  ];

  meta = with lib; {
    description = "Custom Python functions for working with SQLite FTS4";
    homepage = "https://github.com/simonw/sqlite-fts4";
    license = licenses.asl20;
    maintainers = with maintainers; [ meatcar ];
  };
}
