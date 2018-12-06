{ stdenv
, buildPythonPackage
, fetchPypi
, requests-cache
}:

buildPythonPackage rec {
  pname = "tvdb_api";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1de28a5100121d91b1f6a8ec7e86f2c4bdf48fb22fab3c6fe21e7fb7346bf8f";
  };

  propagatedBuildInputs = [ requests-cache ];

  meta = with stdenv.lib; {
    description = "Simple to use TVDB (thetvdb.com) API in Python.";
    homepage = "https://github.com/dbr/tvdb_api";
    license = licenses.unlicense;
    maintainers = with maintainers; [ peterhoeg ];
  };

}
