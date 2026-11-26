{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  jinja2,
  numpy,
  openai,
  openai-harmony,
  prime-pydantic-config,
  tiktoken,

  # optional-dependencies
  pillow,
  transformers,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  torch,
  torchvision,
}:

buildPythonPackage (finalAttrs: {
  pname = "renderers";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PrimeIntellect-ai";
    repo = "renderers";
    tag = "renderers-v${finalAttrs.version}";
    hash = "sha256-iA7eRCFtpiGN3OHVOOXTaEinFrOQS8meAXypPORPjy0=";
  };

  env = {
    SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;
    # Fail fast instead of retrying downloads from the HuggingFace Hub
    HF_HUB_OFFLINE = "1";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    jinja2
    numpy
    openai
    openai-harmony
    prime-pydantic-config
    tiktoken
  ];

  optional-dependencies = lib.fix (self: {
    transformers = [
      transformers
    ];
    multimodal = [
      pillow
    ]
    ++ self.transformers;
  });

  pythonImportsCheck = [ "renderers" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    torch
    torchvision
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # Most tests require downloading tokenizers from the HuggingFace Hub
  enabledTestPaths = [
    "tests/test_client.py"
    "tests/test_incremental.py"
    "tests/test_kimi_k25_tool_schema.py"
    "tests/test_nemotron35_vlm.py"
    "tests/test_nemotron3_ultra.py"
    "tests/test_renderer_config.py"
  ];
  disabledTestMarks = [
    "model"
    "multimodal"
  ];

  meta = {
    description = "Chat template renderers for deterministic message-to-token conversion in LLM training";
    homepage = "https://github.com/PrimeIntellect-ai/renderers";
    changelog = "https://github.com/PrimeIntellect-ai/renderers/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
