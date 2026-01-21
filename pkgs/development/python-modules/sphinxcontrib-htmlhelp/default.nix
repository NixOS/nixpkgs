{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-htmlhelp";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinxcontrib_htmlhelp";
    inherit version;
    hash = "sha256-yeKRas6KrWTME6DSM+4iMX8rkCW5zzKVJJ+phcxwguk=";
  };

  nativeBuildInputs = [ flit-core ];

  # Check is disabled due to circular dependency of sphinx
  dontCheckRuntimeDeps = true;
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx extension which renders HTML help files";
    homepage = "https://github.com/sphinx-doc/sphinxcontrib-htmlhelp";
    license = lib.licenses.bsd2;
  };
}
