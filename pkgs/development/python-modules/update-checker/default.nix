{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  isPy27,
}:

buildPythonPackage rec {
  pname = "update-checker";
  version = "0.18.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    pname = "update_checker";
    inherit version;
    hash = "sha256-ai1Fu0rFhYhKawP56t6RYc7dnoERVFFB6aqQWJMqyxM=";
  };

  propagatedBuildInputs = [ requests ];

  # requires network
  doCheck = false;

  meta = with lib; {
    description = "Python module that will check for package updates";
    homepage = "https://github.com/bboe/update_checker";
    license = licenses.bsd2;
  };
}
