{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sqlite-fts4";
  version = "1.0.3";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-Ibiows3DSnzjIUv7U9tYNVnDaecBBxjXzDqxbIlNhhU=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Custom Python functions for working with SQLite FTS4";
    homepage = "https://github.com/simonw/sqlite-fts4";
    license = licenses.asl20;
    maintainers = with maintainers; [ meatcar ];
  };

}
