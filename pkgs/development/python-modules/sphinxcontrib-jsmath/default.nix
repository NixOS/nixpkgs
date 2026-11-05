{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-jsmath";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-doc";
    repo = "sphinxcontrib-jsmath";
    tag = finalAttrs.version;
    hash = "sha256-CPM+el3nBc3RFZrtjannVXy9NHqXmUwxl9DQmMGzmNQ=";
  };

  build-system = [ flit-core ];

  # Check is disabled due to circular dependency of sphinx
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx extension which renders display math in HTML via JavaScript";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-jsmath";
    license = lib.licenses.bsd0;
  };
})
