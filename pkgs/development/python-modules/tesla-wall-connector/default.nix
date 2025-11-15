{
  lib,
  aiohttp,
  aresponses,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tesla-wall-connector";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "einarhauks";
    repo = "tesla-wall-connector";
    rev = version;
    hash = "sha256-3jj3LU0xRIC6U5DmitkTNjejvSZJWguTS/TeotOD8oc=";
  };

  patches = [
    # https://github.com/einarhauks/tesla-wall-connector/pull/16
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/einarhauks/tesla-wall-connector/commit/4683738b4d2cccb2be337a383243ab3f7623bf8e.patch";
      excludes = [
        ".github/workflows/python-package.yml"
        "poetry.lock"
        "pyproject.toml"
      ];
      hash = "sha256-V9Ra7xA5JzBGe8tE8urVJNqCCdBkNmmqUcXo0cswSoY=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    backoff
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tesla_wall_connector" ];

  meta = with lib; {
    description = "Library for communicating with a Tesla Wall Connector";
    homepage = "https://github.com/einarhauks/tesla-wall-connector";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
