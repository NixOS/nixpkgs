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
    inherit pname version;
    hash = "sha256-zOTviYt+2mhqYIb6zzPJrABtGAkoHbADBnPRZHv+76Q=";
  };

  meta = with lib; {
    homepage = "https://chrisarndt.de/projects/threadpool/";
    description = "Easy to use object-oriented thread pool framework";
    license = licenses.mit;
  };
}
