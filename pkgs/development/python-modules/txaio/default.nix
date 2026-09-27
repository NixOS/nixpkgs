{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "txaio";
  version = "25.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "crossbario";
    repo = "txaio";
    tag = "v${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-/vlkjSOlQYbRpjMySBzoSBSXm0yxWSHmzIF3ZfFIR64=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "txaio" ];

  meta = {
    description = "Utilities to support code that runs unmodified on Twisted and asyncio";
    homepage = "https://github.com/crossbario/txaio";
    changelog = "https://github.com/crossbario/txaio/blob/${finalAttrs.src.tag}/docs/releases.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
