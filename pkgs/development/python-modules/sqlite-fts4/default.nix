{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sqlite-fts4";
  version = "1.0.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    sha256 = "15r1mijk306fpm61viry5wjhqyxlbqqdk4nfcd901qarx7vqypgy";
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
