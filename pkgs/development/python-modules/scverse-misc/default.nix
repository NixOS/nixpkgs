{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  session-info2,
  typing-extensions,

  # optional-dependencies
  # datasets:
  anndata,
  pooch,
  pyyaml,
  tqdm,
  # settings:
  pydantic-settings,
  python-dotenv,
  # sphinx:
  sphinx,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "scverse-misc";
  version = "0.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "scverse-misc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PkvOaxGbZ1i10xgghdvGLCKiXcwg/eZzYvQ7Gp3K+JE=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    session-info2
    typing-extensions
  ];

  optional-dependencies = {
    datasets = [
      anndata
      pooch
      pyyaml
      tqdm
    ];
    settings = [
      pydantic-settings
      python-dotenv
    ];
    spatialdata = [
      # spatialdata (unpackaged)
    ];
    sphinx = [
      # pydocstring-rs (unpackaged)
      sphinx
    ];
  };

  pythonImportsCheck = [ "scverse_misc" ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  meta = {
    description = "Miscellaneous utility code used by scverse packages";
    homepage = "https://github.com/scverse/scverse-misc";
    changelog = "https://github.com/scverse/scverse-misc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
