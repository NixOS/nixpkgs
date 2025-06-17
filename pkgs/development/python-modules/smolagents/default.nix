{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  jinja2,
  pillow,
  python-dotenv,
  requests,
  rich,

  # optional-dependencies
  # audio
  soundfile,
  # bedrock
  boto3,
  # docker
  docker,
  websocket-client,
  # gradio
  gradio,
  # litellm
  litellm,
  # mcp
  mcp,
  mcpadapt,
  # openai
  openai,
  # toolkit
  duckduckgo-search,
  markdownify,
  # torch
  numpy,
  torch,
  torchvision,
  # transformers
  accelerate,
  transformers,

  # tests
  ipython,
  pytest-datadir,
  pytestCheckHook,
  wikipedia-api,
}:

buildPythonPackage rec {
  pname = "smolagents";
  version = "1.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "smolagents";
    tag = "v${version}";
    hash = "sha256-pRpogmVes8ZX19GZff+HmGdykvMnBJ7hGsoYsUGVOSY=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "pillow" ];

  dependencies = [
    huggingface-hub
    jinja2
    pillow
    python-dotenv
    requests
    rich
  ];

  optional-dependencies = lib.fix (self: {
    audio = [ soundfile ] ++ self.torch;
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
    toolkit = [
      duckduckgo-search
      markdownify
    ];
    torch = [
      numpy
      torch
      torchvision
    ];
    transformers = [
      accelerate
      transformers
    ] ++ self.torch;
    # vision = [
    #   helium
    #   selenium
    # ];
    # vllm = [
    #   torch
    #   vllm
    # ];
  });

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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
