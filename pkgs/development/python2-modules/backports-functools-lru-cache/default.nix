{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "backports-functools-lru-cache";
  version = "1.6.6";
  format = "pyproject";

  src = fetchPypi {
    pname = "backports.functools_lru_cache";
    inherit version;
    hash = "sha256-e3DnAbpNtYwO2GcanTORsKu5vRvCTU6Qw0gPS6r8wtw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  # circular dependency:
  # backports-functools-lru-cache -> pytest -> wc-width -> backports-functools-lru-cache
  doCheck = false;

  pythonImportsCheck = [
    "backports.functools_lru_cache"
  ];

  meta = {
    description = "Backport of functools.lru_cache";
    homepage = "https://github.com/jaraco/backports.functools_lru_cache";
    license = lib.licenses.mit;
  };
}

