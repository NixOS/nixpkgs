{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "xstatic-pygments";
  version = "2.9.0.1";

  src = fetchPypi {
    pname = "XStatic-Pygments";
    inherit version;
    hash = "sha256-CCwen+YG+770dPeLb9sZ6aLvzHqbfZQWPPZve/rnV2I=";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://pygments.org";
    description = "pygments packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
