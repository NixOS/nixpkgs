{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  appdirs,
  ecdsa,
  httpx,
  ms-cv,
  pydantic,
  pytest-asyncio_0,
  pytestCheckHook,
  respx,
}:

buildPythonPackage rec {
  pname = "xbox-webapi";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenXbox";
    repo = "xbox-webapi-python";
    rev = "v${version}";
    hash = "sha256-9A3gdSlRjBCx5fBW+jkaSWsFuGieXQKvbEbZzGzLf94=";
  };

  build-system = [ setuptools ];

  dependencies = [
    appdirs
    ecdsa
    httpx
    ms-cv
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytestCheckHook
    respx
  ];

  # https://github.com/OpenXbox/xbox-webapi-python/issues/114
  disabledTests = [ "test_import" ];

  meta = with lib; {
    changelog = "https://github.com/OpenXbox/xbox-webapi-python/blob/${src.rev}/CHANGELOG.md";
    description = "Library to authenticate with Windows Live/Xbox Live and use their API";
    homepage = "https://github.com/OpenXbox/xbox-webapi-python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
