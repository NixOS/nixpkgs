{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "starlark";
  version = "0.5.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "starlark-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J3QgztBmoJBJ8VGl+w7Ybwyuehw8ZEEy6oHIn91tVAY=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "starlark"
  ];

  meta = {
    description = "Starlark in pure Python";
    homepage = "https://github.com/dbohdan/starlark-python";
    changelog = "https://github.com/dbohdan/starlark-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
