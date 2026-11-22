{
  lib,
  buildPythonPackage,
  einops,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "torch-einops-utils";
  version = "0.0.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "torch-einops-utils";
    tag = finalAttrs.version;
    hash = "sha256-ja3HeBvAQRyGL2anqIQa2iiHhOZUhF73do7pvrTyRo0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    einops
    torch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "torch_einops_utils" ];

  meta = {
    description = "Utility functions for torch and einops";
    homepage = "https://github.com/lucidrains/torch-einops-utils";
    changelog = "https://github.com/lucidrains/torch-einops-utils/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})
