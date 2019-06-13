{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "sqlite3dbm";
  version = "0.1.4";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4721607e0b817b89efdba7e79cab881a03164b94777f4cf796ad5dd59a7612c5";
  };

  meta = with stdenv.lib; {
    description = "sqlite-backed dictionary";
    homepage = https://github.com/Yelp/sqlite3dbm;
    license = licenses.asl20;
  };

}
