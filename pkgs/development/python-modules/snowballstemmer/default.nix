{
  lib,
  buildPythonPackage,
  pystemmer,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "snowballstemmer";
  version = "3.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-4Hu8VKDXmP5gEKEjmEIuYqi/u6lcOU/QlW71jLTT4mA=";
  };

  # No tests included
  doCheck = false;

  propagatedBuildInputs = [ pystemmer ];

  meta = {
    description = "16 stemmer algorithms (15 + Poerter English stemmer) generated from Snowball algorithms";
    homepage = "http://sigal.saimon.org/en/latest/index.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
