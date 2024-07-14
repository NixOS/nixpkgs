{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "stookalert";
  version = "0.1.4";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OMR54vt2aPmzev8Pn/3Xv9Huk5NSjy09NrWRG0DacKE=";
  };

  propagatedBuildInputs = [ requests ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "stookalert" ];

  meta = {
    description = "Python package for the RIVM Stookalert";
    homepage = "https://github.com/fwestenberg/stookalert";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
