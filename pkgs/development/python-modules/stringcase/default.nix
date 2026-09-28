{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "stringcase";
  version = "1.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-SKBpgGYZCO/o2dNOqytsE676IWOzztJpcpAuO9/YcAg=";
  };

  build-system = [ setuptools ];

  # PyPi package does not include tests.
  doCheck = false;

  pythonImportsCheck = [ "stringcase" ];

  meta = {
    homepage = "https://github.com/okunishinishi/python-stringcase";
    description = "Convert string cases between camel case, pascal case, snake case etc…";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alunduil ];
  };
})
