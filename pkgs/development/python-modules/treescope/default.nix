{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  flit-core,

  # dependencies
  numpy,

  # optional-dependencies
  ipython,
  jax,
  palettable,

  # tests
  absl-py,
  jaxlib,
  omegaconf,
  pydantic,
  pytestCheckHook,
  torch,
}:

buildPythonPackage (finalAttrs: {
  pname = "treescope";
  version = "0.1.10";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "google-deepmind";
    repo = "treescope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SfycwuI/B7S/rKkaqxtnJI26q89313pvj/Xsomg6qyA=";
  };

  patches = [
    # Handle PyTorch versions without named tensor support (removed in torch 2.13):
    # https://github.com/google-deepmind/treescope/pull/72
    (fetchpatch {
      name = "torch-without-named-tensors.patch";
      url = "https://github.com/google-deepmind/treescope/commit/20a94822d0c4c0a55c10eaa8fed96a77757f4068.patch";
      hash = "sha256-amv4AG2G7TXnzGYBE14mARQh8IYuH3RswtbywTmi4b4=";
    })
  ];

  build-system = [ flit-core ];

  dependencies = [ numpy ];

  optional-dependencies = {
    notebook = [
      ipython
      jax
      palettable
    ];
  };

  pythonImportsCheck = [ "treescope" ];

  nativeCheckInputs = [
    absl-py
    jax
    jaxlib
    omegaconf
    pydantic
    pytestCheckHook
    torch
  ];

  meta = {
    description = "Interactive HTML pretty-printer for machine learning research in IPython notebooks";
    homepage = "https://github.com/google-deepmind/treescope";
    changelog = "https://github.com/google-deepmind/treescope/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
