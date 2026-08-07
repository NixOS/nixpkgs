{
  lib,
  buildPythonPackage,
  fetchFromSourcehut,
  importlib-metadata,
  setuptools,
  sqlparse,
  tabulate,
}:

buildPythonPackage (finalAttrs: {
  pname = "yoyo-migrations";
  version = "9.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromSourcehut {
    owner = "~olly";
    repo = "yoyo";
    vc = "hg";
    tag = "v${finalAttrs.version}-release";
    hash = "sha256-y3dI1NCx/qYW1121ylq5Kk+ha3Rb8a4ObMQCPwiwxC4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    importlib-metadata
    setuptools
    sqlparse
    tabulate
  ];

  doCheck = false; # pypi tarball does not contain tests

  pythonImportsCheck = [ "yoyo" ];

  meta = {
    changelog = "https://hg.sr.ht/~olly/yoyo/browse/CHANGELOG.rst?rev=${finalAttrs.src.tag}";
    description = "Database schema migration tool";
    homepage = "https://ollycope.com/software/yoyo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prusnak ];
  };
})
