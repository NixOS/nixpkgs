{ lib
, buildPythonPackage
, fetchFromGitHub
, requests-cache
, pytest
}:

buildPythonPackage rec {
  pname = "tvdb_api";
  version = "3.2.0-beta";

  src = fetchFromGitHub {
    owner = "dbr";
    repo = "tvdb_api";
    rev = "ce0382181a9e08a5113bfee0fed2c78f8b1e613f";
    hash = "sha256-poUuwySr6+8U9PIHhqFaR7nXzh8kSaW7mZkuKTUJKj8=";
  };

  propagatedBuildInputs = [ requests-cache ];

  nativeCheckInputs = [ pytest ];

  # requires network access
  doCheck = false;

  meta = with lib; {
    description = "Simple to use TVDB (thetvdb.com) API in Python";
    homepage = "https://github.com/dbr/tvdb_api";
    license = licenses.unlicense;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
