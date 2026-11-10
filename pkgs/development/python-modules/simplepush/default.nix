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
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simplepush";
    repo = "simplepush-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xRYFvbrfhsd0qOLAH79sXKBVDdWxTq+cNGQni4783HA=";
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
