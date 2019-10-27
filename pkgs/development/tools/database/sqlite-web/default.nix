{ lib
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlite-web";
  version = "0.3.5";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "9e0c8938434b0129423544162d4ca6975abf7042c131445f79661a4b9c885d47";
  };

  propagatedBuildInputs = with python3Packages; [ flask peewee pygments ];

  # no tests in repository
  doCheck = false;

  meta = with lib; {
    description = "Web-based SQLite database browser";
    homepage = https://github.com/coleifer/sqlite-web;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
