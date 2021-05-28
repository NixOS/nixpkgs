{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, tvdb_api
}:

buildPythonPackage rec {
  pname = "tvnamer";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5512cebb1e49103a1e4ea9629398092b4bbabef35a91007ae0dbed961ebe17dd";
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
