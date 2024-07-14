{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  linecache2,
}:

buildPythonPackage rec {
  version = "1.4.0";
  format = "setuptools";
  pname = "traceback2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BazGegmYDC7P7dNCP3rgEEg57MtV/GRXc+HKoJUcMDA=";
  };

  propagatedBuildInputs = [
    pbr
    linecache2
  ];

  # circular dependencies for tests
  doCheck = false;

  meta = with lib; {
    description = "Backport of traceback to older supported Pythons";
    homepage = "https://pypi.python.org/pypi/traceback2/";
    license = licenses.psfl;
  };
}
