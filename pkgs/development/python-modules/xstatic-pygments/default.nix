{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Pygments";
  version = "2.9.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "082c1e9fe606fbbef474f78b6fdb19e9a2efcc7a9b7d94163cf66f7bfae75762";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = "https://pygments.org";
    description = "pygments packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
