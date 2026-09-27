{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pandas,
  pytestCheckHook,
  scipy,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "slicer";
  version = "0.0.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "interpretml";
    repo = "slicer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kmZQUIgePX1+PQZBA0JuJzjAfXqaOUGb0LLyhbybL18=";
  };

  patches = [
    # Fix pandas 3 compatibility
    # https://github.com/interpretml/slicer/issues/10
    ./pandas-3-compat.patch
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "slicer" ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
    scipy
    torch
  ];

  meta = {
    description = "Wraps tensor-like objects and provides a uniform slicing interface via __getitem__";
    homepage = "https://github.com/interpretml/slicer";
    changelog = "https://github.com/interpretml/slicer/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ evax ];
    platforms = lib.platforms.unix;
  };
})
