{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  warp-lang,

  # tests
  hypothesis,
  pytestCheckHook,
  torch,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "warp-nn";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "warp-nn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dziGJhuuLHy8gEB39tvpLTHjPOwz6YVhsCB6KbIb7vI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    warp-lang
  ];

  pythonImportsCheck = [ "warp_nn" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    torch
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "CUDA Graphable Neural Networks for NVIDIA Warp";
    homepage = "https://github.com/NVIDIA/warp-nn";
    changelog = "https://github.com/NVIDIA/warp-nn/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.tost;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
