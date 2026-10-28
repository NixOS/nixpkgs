{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "zm-py";
  version = "0.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rohankapoorcom";
    repo = "zm-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TXYfZrsrBK10gWvPLM881mSAeeV2v2dQM7sAO/z8gsE=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zoneminder" ];

  meta = {
    description = "Loose python wrapper around the ZoneMinder REST API";
    homepage = "https://github.com/rohankapoorcom/zm-py";
    changelog = "https://github.com/rohankapoorcom/zm-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
})
