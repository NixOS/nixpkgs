{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, certifi
, urllib3

# optional-dependencies
, aiohttp
, anthropic
, asyncpg
, apache-beam
, bottle
, celery
, celery-redbeat
, chalice
, clickhouse-driver
, django
, falcon
, fastapi
, flask
, blinker
, markupsafe
, grpcio
, protobuf
, httpx
, huey
, huggingface-hub
, langchain
, loguru
, openai
, tiktoken
, pure-eval
, executing
, asttokens
, pymongo
, pyspark
, quart
, rq
, sanic
, sqlalchemy
, starlette
, tornado

# checks
, ipdb
, jsonschema
, pip
, pyrsistent
, pysocks
, pytest-asyncio
, pytestCheckHook
, pytest-forked
, pytest-localserver
, pytest-xdist
, pytest-watch
, responses
}:

buildPythonPackage rec {
  pname = "sentry-sdk";
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-python";
    rev = "refs/tags/${version}";
    hash = "sha256-VrrzM81O3tG2GveP8Eq9kxVPSok7JIj3XjGOauGIlxY=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pytest.ini
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
    httpx = [ httpx ];
    huey = [ huey ];
    huggingface-hub = [ huggingface-hub ];
    langchain = [ langchain ];
    loguru = [ loguru ];
    openai = [
      openai
      tiktoken
    ];
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
    tornado = [ tornado ];
  };

  nativeCheckInputs = [
    ipdb
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
  ];

  __darwinAllowLocalNetworking = true;

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
    "test_continuous_profiler_manual_start_and_stop"
  ];

  pythonImportsCheck = [ "sentry_sdk" ];

  meta = with lib; {
    description = "Official Python SDK for Sentry.io";
    homepage = "https://github.com/getsentry/sentry-python";
    changelog = "https://github.com/getsentry/sentry-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
