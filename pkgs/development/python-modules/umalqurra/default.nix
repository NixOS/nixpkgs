{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "umalqurra";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-cZ9qNvkIraHCna4Nk03Q8eH24zBXhO2+wjrXGTl95ng=";
  };

  # No tests included
  doCheck = false;

  # See for license
  # https://github.com/tytkal/python-hijiri-ummalqura/issues/4
  meta = {
    description = "Date Api that support Hijri Umalqurra calendar";
    homepage = "https://github.com/tytkal/python-hijiri-ummalqura";
    license = lib.licenses.publicDomain;
  };
})
