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
    sha256 = "38c479e2fb7668f9b37aff0f9ffdd7bfd1ee9393528f2d3d36b5911b40da70a1";
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
