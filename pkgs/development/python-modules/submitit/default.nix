{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  cloudpickle,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "submitit";
  version = "1.5.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "submitit";
    tag = finalAttrs.version;
    hash = "sha256-Q/2mC7viLYl8fx7dtQueZqT191EbERZPfN0WkTS/U1w=";
  };

  build-system = [ flit-core ];

  dependencies = [
    cloudpickle
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "submitit"
  ];

  disabledTests = [
    # These tests are broken
    "test_setup"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fails in the sandbox:
    #   AssertionError: Should have resumed from a checkpoint
    "test_requeuing"
  ];

  meta = {
    changelog = "https://github.com/facebookincubator/submitit/releases/tag/${finalAttrs.src.tag}";
    description = "Python 3.8+ toolbox for submitting jobs to Slurm";
    homepage = "https://github.com/facebookincubator/submitit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nickcao ];
  };
})
