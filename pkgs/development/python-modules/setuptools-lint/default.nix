{
  lib,
  buildPythonPackage,
  fetchPypi,
  pylint,
}:

buildPythonPackage rec {
  pname = "setuptools-lint";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16a1ac5n7k7sx15cnk03gw3fmslab3a7m74dc45rgpldgiff3577";
  };

  propagatedBuildInputs = [ pylint ];

  meta = with lib; {
    description = "Package to expose pylint as a lint command into setup.py";
    homepage = "https://github.com/johnnoone/setuptools-pylint";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ nickhu ];
  };
}
