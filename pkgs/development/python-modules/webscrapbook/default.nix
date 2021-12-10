{ buildPythonPackage
, flask
, werkzeug
, jinja2
, lxml
, CommonMark
, cryptography
, lib
, fetchFromGitHub
}:

buildPythonPackage rec {
  name = "webscrapbook";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "danny0838";
    repo = "PyWebScrapBook";
    rev = version;
    sha256 = "f43Xp8LBdGnwv5qzYS5prgbNRQS7IwkIjlqAKUzxeh4=";
  };

  propagatedBuildInputs = [ flask werkzeug jinja2 lxml CommonMark cryptography ];

  meta = with lib; {
    description = "Server backend and CLI toolkit for WebScrapBook browser extension";
    homepage = "https://github.com/danny0838/PyWebScrapBook";
    license = licenses.mit;
    maintainers = with maintainers; [ milahu ];
  };
}
