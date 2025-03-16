{
  lib,
  accelerate,
  buildPythonPackage,
  docker,
  duckduckgo-search,
  fetchFromGitHub,
  gradio,
  huggingface-hub,
  jinja2,
  ipython,
  litellm,
  markdownify,
  mcp,
  openai,
  pandas,
  pillow,
  pytestCheckHook,
  python-dotenv,
  rank-bm25,
  requests,
  rich,
  setuptools,
  soundfile,
  torch,
  torchvision,
  transformers,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "smolagents";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "smolagents";
    tag = "v${version}";
    hash = "sha256-6+fI5Zp2UyDgcCUXYT34zumDBqkIeW+TXnRNA+SFoxI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    duckduckgo-search
    huggingface-hub
    jinja2
    markdownify
    pandas
    pillow
    python-dotenv
    requests
    rich
  ];

  optional-dependencies = {
    audio = [ soundfile ];
    docker = [
      docker
      websocket-client
    ];
    # e2b = [
    #   e2b-code-interpreter
    #   python-dotenv
    # ];
    gradio = [ gradio ];
    litellm = [ litellm ];
    mcp = [
      mcp
      # mcpadapt
    ];
    # mlx-lm = [ mlx-lm ];
    openai = [ openai ];
    # telemetry = [
    #   arize-phoenix
    #   openinference-instrumentation-smolagents
    #   opentelemetry-exporter-otlp
    #   opentelemetry-sdk
    # ];
    torch = [
      torch
      torchvision
    ];
    transformers = [
      accelerate
      transformers
    ];
    # vision = [
    #   helium
    #   selenium
    # ];
    # vllm = [
    #   torch
    #   vllm
    # ];
  };

  nativeCheckInputs = [
    ipython
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "smolagents" ];

  disabledTests = [
    # Missing dependencies
    "test_ddgs_with_kwargs"
    "test_e2b_executor_instantiation"
    "test_flatten_messages_as_text_for_all_models"
    "test_from_mcp"
    "test_import_smolagents_without_extras"
    "test_vision_web_browser_main"
    # Tests require network access
    "test_agent_type_output"
    "test_can_import_sklearn_if_explicitly_authorized"
    "test_transformers_message_no_tool"
    "test_transformers_message_vl_no_tool"
    "test_transformers_toolcalling_agent"
    "test_visit_webpage"
  ];

  meta = {
    description = "Barebones library for agents";
    homepage = "https://github.com/huggingface/smolagents";
    changelog = "https://github.com/huggingface/smolagents/releases/tag/v${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
