{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  certifi,
  urllib3,

  # optional-dependencies
  aiohttp,
  anthropic,
  apache-beam,
  asttokens,
  asyncpg,
  blinker,
  bottle,
  celery,
  celery-redbeat,
  chalice,
  clickhouse-driver,
  django,
  executing,
  falcon,
  fastapi,
  flask,
  grpcio,
  httpcore,
  httpx,
  huey,
  huggingface-hub,
  langchain,
  litestar,
  loguru,
  markupsafe,
  openai,
  protobuf,
  pure-eval,
  pymongo,
  pyspark,
  quart,
  rq,
  sanic,
  sqlalchemy,
  starlette,
  tiktoken,
  tornado,

  # checks
  brotli,
  jsonschema,
  pip,
  pyrsistent,
  pysocks,
  pytest-asyncio,
  pytestCheckHook,
  pytest-forked,
  pytest-localserver,
  pytest-xdist,
  pytest-watch,
  responses,
  stdenv,
}:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "2.39.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-python";
    tag = version;
    hash = "sha256-2M5Uvo8dl6hOqY13Eqjo4aKFySdlqEO8BHrPxZ/l+fw=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pyproject.toml
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    certifi
    urllib3
  ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    anthropic = [ anthropic ];
    # TODO: arq
    asyncpg = [ asyncpg ];
    beam = [ apache-beam ];
    bottle = [ bottle ];
    celery = [ celery ];
    celery-redbeat = [ celery-redbeat ];
    chalice = [ chalice ];
    clickhouse-driver = [ clickhouse-driver ];
    django = [ django ];
    falcon = [ falcon ];
    fastapi = [ fastapi ];
    flask = [
      blinker
      flask
      markupsafe
    ];
    grpcio = [
      grpcio
      protobuf
    ];
    http2 = [ httpcore ] ++ httpcore.optional-dependencies.http2;
    httpx = [ httpx ];
    huey = [ huey ];
    huggingface-hub = [ huggingface-hub ];
    langchain = [ langchain ];
    # TODO: launchdarkly
    litestar = [ litestar ];
    loguru = [ loguru ];
    openai = [
      openai
      tiktoken
    ];
    # TODO: openfeature
    # TODO: opentelemetry
    # TODO: opentelemetry-experimental
    pure_eval = [
      asttokens
      executing
      pure-eval
    ];
    pymongo = [ pymongo ];
    pyspark = [ pyspark ];
    quart = [
      blinker
      quart
    ];
    rq = [ rq ];
    sanic = [ sanic ];
    sqlalchemy = [ sqlalchemy ];
    starlette = [ starlette ];
    # TODO: starlite
    # TODO: statsig
    tornado = [ tornado ];
    # TODO: unleash
  };

  nativeCheckInputs = [
    brotli
    pyrsistent
    responses
    pysocks
    setuptools
    executing
    jsonschema
    pip
    pytest-asyncio
    pytest-forked
    pytest-localserver
    pytest-xdist
    pytest-watch
    pytestCheckHook
  ]
  ++ optional-dependencies.http2;

  __darwinAllowLocalNetworking = true;

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # darwin: 'profiler should not be running'
    "tests/profiler/test_continuous_profiler.py"
  ];

  disabledTests = [
    # depends on git revision
    "test_default_release"
    # tries to pip install old setuptools version
    "test_error_has_existing_trace_context_performance_disabled"
    "test_error_has_existing_trace_context_performance_enabled"
    "test_error_has_new_trace_context_performance_disabled"
    "test_error_has_new_trace_context_performance_enabled"
    "test_traces_sampler_gets_correct_values_in_sampling_context"
    "test_performance_error"
    "test_performance_no_error"
    "test_timeout_error"
    "test_handled_exception"
    "test_unhandled_exception"
    # network access
    "test_create_connection_trace"
    "test_crumb_capture"
    "test_getaddrinfo_trace"
    "test_omit_url_data_if_parsing_fails"
    "test_span_origin"
    # AttributeError: type object 'ABCMeta' has no attribute 'setup_once'
    "test_ensure_integration_enabled_async_no_original_function_enabled"
    "test_ensure_integration_enabled_no_original_function_enabled"
    # sess = envelopes[1]
    # IndexError: list index out of range
    "test_session_mode_defaults_to_request_mode_in_wsgi_handler"
    # assert count_item_types["sessions"] == 1
    # assert 0 == 1
    "test_auto_session_tracking_with_aggregates"
    # timing sensitive
    "test_profile_captured"
    "test_continuous_profiler_auto"
    "test_continuous_profiler_manual"
    "test_stacktrace_big_recursion"
    # assert ('socks' in "<class 'httpcore.connectionpool'>") == True
    "test_socks_proxy"
    # requires socksio to mock, but that crashes pytest-forked
    "test_http_timeout"
    # KeyError: 'sentry.release'
    "test_logs_attributes"
    "test_logger_with_all_attributes"
  ];

  pythonImportsCheck = [ "sentry_sdk" ];

  meta = with lib; {
    description = "Official Python SDK for Sentry.io";
    homepage = "https://github.com/getsentry/sentry-python";
    changelog = "https://github.com/getsentry/sentry-python/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
