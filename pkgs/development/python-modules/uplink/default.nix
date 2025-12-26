{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
  six,
  uritemplate,
  pytestCheckHook,
  pytest-mock,
  aiohttp,
  marshmallow,
  pydantic,
  pytest-asyncio,
  pytest-twisted,
  twisted,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "uplink";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prkumar";
    repo = "uplink";
    tag = "v${version}";
    hash = "sha256-gI7oHLyC6a5s3jhgG5jj+7q495seMSyUV4XVAp1URTA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    six
    uritemplate
  ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    marshmallow = [ marshmallow ];
    pydantic = [ pydantic ];
    twisted = [ twisted ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-asyncio
    pytest-twisted
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "uplink" ];

  meta = {
    description = "Declarative HTTP client for Python";
    homepage = "https://github.com/prkumar/uplink";
    changelog = "https://github.com/prkumar/uplink/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
