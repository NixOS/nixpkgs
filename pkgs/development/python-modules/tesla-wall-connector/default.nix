{ lib
, aiohttp
, backoff
, aioresponses
, buildPythonPackage
, fetchPypi
, pytest-aiohttp
, pytestCheckHook
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tesla-wall-connector";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "PVgM6tC8jy/tXytkAVC0Y4Oatap5YFA3vpkUgAdyTxM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
  ];

  # https://github.com/einarhauks/tesla-wall-connector/issues/1
  doCheck = false;

  pythonImportsCheck = [
    "tesla_wall_connector"
  ];

  meta = with lib; {
    description = "Python library for communicating with a Tesla Wall Connector";
    homepage = "https://github.com/einarhauks/tesla-wall-connector";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
