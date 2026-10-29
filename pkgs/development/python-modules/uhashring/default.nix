{
  lib,
  buildPythonPackage,
  pytestCheckHook,
  fetchFromGitHub,
  hatchling,
  python-memcached,
}:
buildPythonPackage (finalAttrs: {
  pname = "uhashring";
  version = "2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ultrabug";
    repo = "uhashring";
    tag = finalAttrs.version;
    hash = "sha256-rxYAqzyGqS+Pp70jD36bvXJHvMshUWbTvmqB+H+3BAM=";
  };

  build-system = [
    hatchling
  ];

  pythonImportsCheck = [
    "uhashring"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    python-memcached
  ];

  meta = {
    description = "Full featured consistent hashing python library compatible with ketama";
    homepage = "https://github.com/ultrabug/uhashring";
    changelog = "https://github.com/ultrabug/uhashring/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ typedrat ];
  };
})
