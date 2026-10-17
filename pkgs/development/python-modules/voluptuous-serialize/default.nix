{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "voluptuous-serialize";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "voluptuous-serialize";
    tag = version;
    hash = "sha256-vmBK4FJr15wOYHtH14OqeyY/vgVOSrpo0Sd9wqu4zgo=";
  };

  build-system = [ setuptools ];

  dependencies = [ voluptuous ];

  pythonImportsCheck = [ "voluptuous_serialize" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Convert Voluptuous schemas to dictionaries so they can be serialized";
    homepage = "https://github.com/home-assistant-libs/voluptuous-serialize";
    changelog = "https://github.com/home-assistant-libs/voluptuous-serialize/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
