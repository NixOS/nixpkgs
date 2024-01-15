{ lib
, python3Packages
, fetchPypi
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlite-web";
  version = "0.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17pymadm063358nji70xzma64zkfv26c3pai5i1whsfp9ahqzasg";
  };

  propagatedBuildInputs = with python3Packages; [ flask peewee pygments ];

  # no tests in repository
  doCheck = false;

  meta = with lib; {
    description = "Web-based SQLite database browser";
    homepage = "https://github.com/coleifer/sqlite-web";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
