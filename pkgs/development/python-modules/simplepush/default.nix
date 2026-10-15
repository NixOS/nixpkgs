{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  cryptography,
  pynacl,
  websockets,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "simplepush";
  version = "3.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simplepush";
    repo = "simplepush-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J/kP0D70Ry+Wq081SH/Mn9RLTjBDQ0h/UBFa8k0PMIU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    websockets
  ];

  optional-dependencies = {
    crypto = [ pynacl ];
    legacy = [ cryptography ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "simplepush" ];

  meta = {
    description = "Module to send push notifications via Simplepush";
    homepage = "https://github.com/simplepush/simplepush-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
