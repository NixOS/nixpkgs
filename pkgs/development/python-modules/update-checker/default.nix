{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "update-checker";
  version = "0.18.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "update_checker";
    inherit version;
    hash = "sha256-ai1Fu0rFhYhKawP56t6RYc7dnoERVFFB6aqQWJMqyxM=";
  };

  propagatedBuildInputs = [ requests ];

  # requires network
  doCheck = false;

  meta = {
    description = "Python module that will check for package updates";
    homepage = "https://github.com/bboe/update_checker";
    license = lib.licenses.bsd2;
  };
}
