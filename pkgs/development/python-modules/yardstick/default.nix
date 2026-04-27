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
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anchore";
    repo = "yardstick";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4Kwgm2gmgOam7AVzlGYT3QhAyJf14h3pZohrhbzprpg=";
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
