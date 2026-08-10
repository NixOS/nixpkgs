{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  orjson,
  pytest-cov-stub,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "steamloop";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hvaclibs";
    repo = "steamloop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7AxUEe57OpDi2ofbKWvdcFCoq7ARXtlKpiJQyQX891c=";
  };

  build-system = [ setuptools ];

  dependencies = [ orjson ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "steamloop" ];

  meta = {
    description = "Local control for choochoo based thermostats";
    homepage = "https://github.com/hvaclibs/steamloop";
    changelog = "https://github.com/hvaclibs/steamloop/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
