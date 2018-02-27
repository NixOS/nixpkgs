{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tmdb3";
  version = "0.6.17";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "64a6c3f1a60a9d8bf18f96a5403f3735b334040345ac3646064931c209720972";
  };

  meta = with lib; {
    description = "Python implementation of the v3 API for TheMovieDB.org, allowing access to movie and cast information";
    homepage = https://pypi.python.org/pypi/tmdb3;
    license = licenses.bsd3;
  };
}
