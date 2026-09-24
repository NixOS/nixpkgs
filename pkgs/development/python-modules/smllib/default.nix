{
  lib,

  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "smllib";
  version = "1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spacemanspiff2007";
    repo = "smllib";
    tag = finalAttrs.version;
    hash = "sha256-jf9AFjt9xDg4DFYzdoL7rQdo/WdkM4km8fDdzVfbN5E=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [
    "smllib"
  ];

  meta = {
    description = "Library to parse SML byte streams";
    homepage = "https://github.com/spacemanspiff2007/SmlLib";
    changelog = "https://github.com/spacemanspiff2007/SmlLib/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ hensoko ];
  };
})
