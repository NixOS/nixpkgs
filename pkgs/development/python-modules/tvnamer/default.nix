{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, tvdb_api
}:

buildPythonPackage rec {
  pname = "tvnamer";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0szg3k9zcnba7a8fw1fz3hr72lwlysfbm7hkabkaik69vra77bh0";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ tvdb_api ];

  # a ton of tests fail with: IOError: tvnamer/main.py could not be found in . or ..
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Automatic TV episode file renamer, uses data from thetvdb.com via tvdb_api.";
    homepage = "https://github.com/dbr/tvnamer";
    license = licenses.unlicense;
    maintainers = with maintainers; [ peterhoeg ];
  };

}
