{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pystemmer,
}:

buildPythonPackage (finalAttrs: {
  pname = "snowballstemmer";
  version = "3.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-bV7u7I6fhNTVa4R2krrPebwsjpDH+AykRE/4tvLlKJU=";
  };

  build-system = [ setuptools ];

  dependencies = [ pystemmer ];

  # No tests included
  doCheck = false;

  meta = {
    description = "16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms";
    homepage = "https://snowballstem.org/";
    changelog = "https://github.com/snowballstem/snowball/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
