{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  itsdangerous,
  redis,
  starlette,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  httpx,
}:

buildPythonPackage rec {
  pname = "starsessions";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alex-oleshkevich";
    repo = "starsessions";
    tag = "v${version}";
    hash = "sha256-JI044sn6LQI37PvSLdz2dooa3v5qdHmp6DZD0p7VzJU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    itsdangerous
    starlette
  ];

  pythonImportsCheck = [ "starsessions" ];

  optional-dependencies = {
    redis = [
      redis
    ];
  };

  nativeCheckInputs = [
    httpx
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  disabledTestPaths = [
    "tests/backends/test_redis.py" # requires a running redis instance
  ];

  meta = {
    description = "Advanced sessions for Starlette and FastAPI frameworks";
    homepage = "https://github.com/alex-oleshkevich/starsessions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
