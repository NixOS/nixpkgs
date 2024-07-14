{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "xstatic-bootstrap";
  version = "4.5.3.1";

  src = fetchPypi {
    pname = "XStatic-Bootstrap";
    inherit version;
    hash = "sha256-z2fSBUN7MlCKiLaafnxbviylqK5xCXORpqb1EOv9KCA=";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://getbootstrap.com";
    description = "Bootstrap packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
