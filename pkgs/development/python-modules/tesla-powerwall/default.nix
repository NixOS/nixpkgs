{ lib
, buildPythonPackage
, fetchPypi
, requests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "tesla-powerwall";
  version = "0.3.17";

  format = "setuptools";

  src = fetchPypi {
    pname = "tesla_powerwall";
    inherit version;
    sha256 = "09351e408e8e3cc03414944c1a487ef2178300829559e80835026acb84330cfd";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  pytestFlagsArray = [
    "tests/unit"
  ];

  pythonImportsCheck = [ "tesla_powerwall" ];

  meta = {
    description = "API for Tesla Powerwall";
    homepage = "https://github.com/jrester/tesla_powerwall";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
