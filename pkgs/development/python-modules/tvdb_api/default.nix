{ stdenv
, buildPythonPackage
, fetchPypi
, requests-cache
}:

buildPythonPackage rec {
  pname = "tvdb_api";
  version = "1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hq887yb3rwc0rcw32lh7xdkk9bbrqy274aspzqkd6f7dyhp73ih";
  };

  propagatedBuildInputs = [ requests-cache ];

  meta = with stdenv.lib; {
    description = "Simple to use TVDB (thetvdb.com) API in Python.";
    homepage = "https://github.com/dbr/tvdb_api";
    license = licenses.unlicense;
    maintainers = with maintainers; [ peterhoeg ];
  };

}
