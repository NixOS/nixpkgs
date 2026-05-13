{
  lib,
  buildPythonPackage,
  click,
  dataclass-wizard,
  dataclasses-json,
  fetchFromGitHub,
  gitpython,
  hatchling,
  importlib-metadata,
  mergedeep,
  omitempty,
  prompt-toolkit,
  pygments,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  requests,
  tabulate,
  uv-dynamic-versioning,
  xxhash,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "yardstick";
  version = "0.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anchore";
    repo = "yardstick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jKf1LH+YLRuds/5SKSgKm8PbI9OvkxgBhm5vOmg5EU0=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    click
    dataclass-wizard
    dataclasses-json
    gitpython
    importlib-metadata
    mergedeep
    omitempty
    prompt-toolkit
    pygments
    pyyaml
    requests
    tabulate
    xxhash
    zstandard
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "yardstick" ];

  meta = {
    description = "Module to compare vulnerability scanners results";
    homepage = "https://github.com/anchore/yardstick";
    changelog = "https://github.com/anchore/yardstick/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
