{
  lib,
  stdenv,
  accelerate,
  buildPythonPackage,
  boto3,
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
  mcpadapt,
  openai,
  pandas,
  pillow,
  pytest-datadir,
  pytestCheckHook,
  python-dotenv,
  requests,
  rich,
  setuptools,
  soundfile,
  torch,
  torchvision,
  transformers,
  websocket-client,
  wikipedia-api,
}:

buildPythonPackage rec {
  pname = "smolagents";
  version = "1.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "smolagents";
    tag = "v${version}";
    hash = "sha256-BMyLN8eNGBhywpN/EEE8hFf4Wb5EDpZvqBbX0ojRYec=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "pillow" ];

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
    bedrock = [ boto3 ];
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
      mcpadapt
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
    pytest-datadir
    pytestCheckHook
    wikipedia-api
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "smolagents" ];

  disabledTests =
    [
      # Missing dependencies
      "test_ddgs_with_kwargs"
      "test_e2b_executor_instantiation"
      "test_flatten_messages_as_text_for_all_models"
      "mcp"
      "test_import_smolagents_without_extras"
      "test_vision_web_browser_main"
      "test_multiple_servers"
      # Tests require network access
      "test_agent_type_output"
      "test_call_different_providers_without_key"
      "test_can_import_sklearn_if_explicitly_authorized"
      "test_transformers_message_no_tool"
      "test_transformers_message_vl_no_tool"
      "test_transformers_toolcalling_agent"
      "test_visit_webpage"
      "test_wikipedia_search"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # Missing dependencies
      "test_get_mlx"

      # Fatal Python error: Aborted
      # thread '<unnamed>' panicked, Attempted to create a NULL object.
      # duckduckgo_search/duckduckgo_search.py", line 83 in __init__
      "TestDuckDuckGoSearchTool"
      "test_init_agent_with_different_toolsets"
      "test_multiagents_save"
      "test_new_instance"
    ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Barebones library for agents";
    homepage = "https://github.com/huggingface/smolagents";
    changelog = "https://github.com/huggingface/smolagents/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
