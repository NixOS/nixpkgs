{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "threadpool";
  version = "1.3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "threadpool";
    extension = "zip";
    hash = "sha256-aju7DA584m/08kGTwVRkWVdUvUb4fYQSanwnc923uco=";
  };

  meta = {
    homepage = "https://chrisarndt.de/projects/threadpool/";
    description = "Easy to use object-oriented thread pool framework";
    license = lib.licenses.mit;
  };
}
