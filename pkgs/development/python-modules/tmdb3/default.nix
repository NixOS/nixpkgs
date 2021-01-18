{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "tmdb3";
  version = "0.7.2";
  disabled = isPy3k; # Upstream has not received any updates since 2015, and importing from python3 does not work.

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b6e043b8a65d159e7fc8f720badc7ffee5109296e38676c107454e03a895983";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "tmdb3" ];

  meta = with lib; {
    description = "Python implementation of the v3 API for TheMovieDB.org, allowing access to movie and cast information";
    homepage = "https://pypi.python.org/pypi/tmdb3";
    license = licenses.bsd3;
  };
}
