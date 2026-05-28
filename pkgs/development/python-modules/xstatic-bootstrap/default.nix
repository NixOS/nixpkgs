{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "xstatic-bootstrap";
  version = "5.3.8.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "xstatic_bootstrap";
    inherit version;
    hash = "sha256-BPXMlbvlQ40ehR0GxMoa1/hL02oJtN5aH1S1JOhQaFk=";
  };

  # no tests implemented
  doCheck = false;

  meta = {
    homepage = "https://getbootstrap.com";
    description = "Bootstrap packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
}
