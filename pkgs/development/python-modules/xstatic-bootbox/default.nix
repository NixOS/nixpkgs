{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xstatic-bootbox";
  version = "5.5.1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "XStatic-Bootbox";
    inherit version;
    sha256 = "4b2120bb33a1d8ada8f9e0532ad99987aa03879b17b08bfdc6b8326d6eb7c205";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  meta = {
    homepage = "https://bootboxjs.com";
    description = "Bootboxjs packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
}
