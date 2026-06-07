{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "xstatic-pygments";
  version = "2.9.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "XStatic-Pygments";
    inherit version;
    sha256 = "082c1e9fe606fbbef474f78b6fdb19e9a2efcc7a9b7d94163cf66f7bfae75762";
  };

  # no tests implemented
  doCheck = false;

  meta = {
    homepage = "https://pygments.org";
    description = "Pygments packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
}
