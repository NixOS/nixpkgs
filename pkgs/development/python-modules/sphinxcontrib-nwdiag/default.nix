{
  lib,
  blockdiag,
  buildPythonPackage,
  fetchPypi,
  nwdiag,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-nwdiag";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bula1DutRv6NwfZRhciZfLHRZmXu42p+qvbeExN/+Fk=";
  };

  propagatedBuildInputs = [
    blockdiag
    nwdiag
    sphinx
  ];

  pythonImportsCheck = [ "sphinxcontrib.nwdiag" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx nwdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-nwdiag";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
