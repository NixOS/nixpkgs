{
  lib,
  buildPythonPackage,
  fetchFromCodeberg,
  aiohttp,
  pydantic,
  uv-build,
  pytestCheckHook,
  pytest-asyncio,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "teltasync";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "dmho";
    repo = "teltasync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-skTJyWkDplgGJ5al6YMVnFAo1Js1yc5ViKUiPm9hhJg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.10.2,<0.11.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    aiohttp
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    syrupy
  ];

  pythonImportsCheck = [ "teltasync" ];

  meta = {
    description = "Async, typed API client for Teltonika routers, built for Home Assistant";
    homepage = "https://codeberg.org/dmho/teltasync";
    changelog = "https://codeberg.org/dmho/teltasync/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.karlbeecken ];
  };
})
