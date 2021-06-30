{ lib
, buildPythonPackage
, fetchPypi
, pytest
, tvdb_api
}:

buildPythonPackage rec {
  pname = "tvnamer";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dc2ea8188df6ac56439343630466b874c57756dd0b2538dd8e7905048f425f04";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ tvdb_api ];

  # a ton of tests fail with: IOError: tvnamer/main.py could not be found in . or ..
  doCheck = false;

  meta = with lib; {
    description = "Automatic TV episode file renamer, uses data from thetvdb.com via tvdb_api.";
    homepage = "https://github.com/dbr/tvnamer";
    license = licenses.unlicense;
    maintainers = with maintainers; [ peterhoeg ];
  };

}
