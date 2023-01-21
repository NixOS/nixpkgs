{ lib
, buildPythonPackage
, fetchPypi
, requests-cache
, pytest
}:

buildPythonPackage rec {
  pname = "tvdb_api";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f63f6db99441bb202368d44aaabc956acc4202b18fc343a66bf724383ee1f563";
  };

  propagatedBuildInputs = [ requests-cache ];

  nativeCheckInputs = [ pytest ];

  # requires network access
  doCheck = false;

  meta = with lib; {
    description = "Simple to use TVDB (thetvdb.com) API in Python";
    homepage = "https://github.com/dbr/tvdb_api";
    license = licenses.unlicense;
    maintainers = with maintainers; [ peterhoeg ];
    # https://github.com/dbr/tvdb_api/issues/94
    broken = true;
  };
}
