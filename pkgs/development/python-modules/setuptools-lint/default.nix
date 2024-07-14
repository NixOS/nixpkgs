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
    hash = "sha256-55ThXHyN3pcLYY2cetRYiurqBn8DTMtK6PrMYwtTQZk=";
  };

  propagatedBuildInputs = [ pylint ];

  meta = with lib; {
    description = "Package to expose pylint as a lint command into setup.py";
    homepage = "https://github.com/johnnoone/setuptools-pylint";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ nickhu ];
  };
}
