{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, tvdb_api
}:

buildPythonPackage rec {
  pname = "tvnamer";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba181a947dcfe20c860825b3580d2a6f1a896cf9b5fef093b8c3f00640581a1f";
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
