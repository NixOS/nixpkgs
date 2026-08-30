{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  sphinx,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-log-cabinet";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "davidism";
    repo = "sphinxcontrib-log-cabinet";
    tag = finalAttrs.version;
    hash = "sha256-wXIDNHQelApRkaTv2wyGRD+yTDa9TazJwekqjd/VnQ0=";
  };

  propagatedBuildInputs = [ sphinx ];

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
