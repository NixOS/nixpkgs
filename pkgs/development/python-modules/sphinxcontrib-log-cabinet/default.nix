{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-log-cabinet";
  version = "1.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "davidism";
    repo = "sphinxcontrib-log-cabinet";
    tag = finalAttrs.version;
    hash = "sha256-wXIDNHQelApRkaTv2wyGRD+yTDa9TazJwekqjd/VnQ0=";
  };

  build-system = [ setuptools ];

  dependencies = [ sphinx ];

  pythonImportsCheck = [ "sphinxcontrib.log_cabinet" ];

  doCheck = false; # no tests

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    homepage = "https://github.com/davidism/sphinxcontrib-log-cabinet";
    description = "Sphinx extension to organize changelogs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
  };
})
