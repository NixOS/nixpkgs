{ stdenv
, buildPythonPackage
, fetchPypi
, requests-cache
, pytest
}:

buildPythonPackage rec {
  pname = "tvdb_api";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a0135815cb680da38d78121d4d659d8e54a25f4db2816cd86d62916b92f23b2";
  };

  propagatedBuildInputs = [ requests-cache ];

  checkInputs = [ pytest ];

  # requires network access
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple to use TVDB (thetvdb.com) API in Python";
    homepage = "https://github.com/dbr/tvdb_api";
    license = licenses.unlicense;
    maintainers = with maintainers; [ peterhoeg ];
  };

}
