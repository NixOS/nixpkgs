{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "xmod";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rec";
    repo = "xmod";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YHzBmmrIw30+dqseMHjtSYBkdo49PeWDxopooBzlXig=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals (pythonAtLeast "3.15")[
    "test_dir"
    "test_dir2"
  ];

  pythonImportsCheck = [ "xmod" ];

  meta = {
    description = "Turn any object into a module";
    homepage = "https://github.com/rec/xmod";
    changelog = "https://github.com/rec/xmod/blob/${finalAttrs.src.tag}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
