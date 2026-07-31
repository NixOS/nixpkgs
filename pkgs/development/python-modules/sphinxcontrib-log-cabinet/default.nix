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

  src = fetchFromGitHub {
    owner = "davidism";
    repo = "sphinxcontrib-log-cabinet";
    tag = finalAttrs.version;
    sha256 = "03cxspgqsap9q74sqkdx6r6b4gs4hq6dpvx4j58hm50yfhs06wn1";
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
