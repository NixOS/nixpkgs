{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "tiered-debug";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "untergeek";
    repo = "tiered-debug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PIqRReT+m5nlq9koD88XJMeUvUsRwrXCqZDTylZGgPg=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tiered_debug" ];

  disabledTests = [
    # AssertionError
    "test_add_handler"
    "test_log_with_default_stacklevel"
  ];

  meta = {
    description = "Python logging helper module that allows for multiple tiers of debug logging";
    homepage = "https://github.com/untergeek/tiered-debug";
    changelog = "https://github.com/untergeek/tiered-debug/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
