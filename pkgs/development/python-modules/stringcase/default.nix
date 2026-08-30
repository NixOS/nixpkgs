{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "stringcase";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SKBpgGYZCO/o2dNOqytsE676IWOzztJpcpAuO9/YcAg=";
  };

  # PyPi package does not include tests.
  doCheck = false;

  meta = {
    homepage = "https://github.com/okunishinishi/python-stringcase";
    description = "Convert string cases between camel case, pascal case, snake case etc…";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alunduil ];
  };
}
