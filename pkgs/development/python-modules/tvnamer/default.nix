{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, tvdb_api
}:

buildPythonPackage rec {
  pname = "tvnamer";
  version = "2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10iizmwna2xpyc2694hsrvny68y3bdq576p8kxsvg5gj2spnsxav";
  };

  buildInputs = [ pytest ];
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
