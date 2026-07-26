{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic-pygments";
  version = "2.9.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "XStatic-Pygments";
    inherit (finalAttrs) version;
    hash = "sha256-CCwen+YG+770dPeLb9sZ6aLvzHqbfZQWPPZve/rnV2I=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  meta = {
    homepage = "https://pygments.org";
    description = "Pygments packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
