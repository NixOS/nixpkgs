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
}:

buildPythonPackage rec {
  pname = "tesla-wall-connector";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "einarhauks";
    repo = "tesla-wall-connector";
    tag = version;
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

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    backoff
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tesla_wall_connector" ];

  meta = {
    changelog = "https://github.com/einarhauks/tesla-wall-connector/releases/tag/${src.tag}";
    description = "Library for communicating with a Tesla Wall Connector";
    homepage = "https://github.com/einarhauks/tesla-wall-connector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
