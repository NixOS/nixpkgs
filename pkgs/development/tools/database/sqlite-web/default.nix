{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlite-web";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cDSlSh0vnwvbJZFDPqvJ5oXz68gN9yzodcQYkXUAytE=";
  };

  propagatedBuildInputs = with python3Packages; [
    flask
    peewee
    pygments
  ];

  # no tests in repository
  doCheck = false;

  meta = with lib; {
    description = "Web-based SQLite database browser";
    mainProgram = "sqlite_web";
    homepage = "https://github.com/coleifer/sqlite-web";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
