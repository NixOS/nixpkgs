{
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "lektricowifi";
  version = "0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lektrico";
    repo = "lektricowifi";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-lAncBgk0/j35NthaOc9ZMrmRkBtiqELYyPA5Tvju8c8=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "pydantic"
  ];

  dependencies = [
    async-timeout
    httpx
    pydantic
  ];

  pythonImportsCheck = [ "lektricowifi" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    description = "Communication with Lektrico's chargers";
    homepage = "https://github.com/Lektrico/lektricowifi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
