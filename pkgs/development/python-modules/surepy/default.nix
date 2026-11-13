{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov,
  pytestCheckHook,
  rich,
}:

buildPythonPackage rec {
  pname = "surepy";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "benleb";
    repo = "surepy";
    tag = "v${version}";
    hash = "sha256-b93SqZr+9VKYHoFxkutZ01LsuvtGiDO5FrHIrZvho94=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    click
    rich
  ]
  ++ aiohttp.optional-dependencies.speedups;

  # tests require to configure a token
  doCheck = false;

  pythonImportsCheck = [ "surepy" ];

  meta = {
    description = "Python library to interact with the Sure Petcare API";
    homepage = "https://github.com/benleb/surepy";
    changelog = "https://github.com/benleb/surepy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "surepy";
  };
}
