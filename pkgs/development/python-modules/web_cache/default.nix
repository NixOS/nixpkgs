{ stdenv, fetchPypi, buildPythonPackage, isPy3k }:

buildPythonPackage rec {
  pname = "web_cache";
  version = "1.0.2";
  name = "${pname}-${version}";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "05mmxf5f312mi9g417zad20f8v76wjm36b0v75x96diffccaafp0";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple Python key-value storage backed up by sqlite3 database";
    homepage = https://github.com/desbma/web_cache;
    license = licenses.lgpl21;
  };
}
