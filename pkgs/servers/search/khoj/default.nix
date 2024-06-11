{ lib
, stdenv
, fetchFromGitHub
, python3
, postgresql
, postgresqlTestHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "khoj";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "debanjum";
    repo = "khoj";
    rev = "refs/tags/${version}";
    hash = "sha256-lvOeYTrvW5MfhuJ3lj9n9TRlvpRwVP2vFeaEeJdqIec=";
  };

  env = {
    DJANGO_SETTINGS_MODULE = "khoj.app.settings";
    postgresqlEnableTCP = 1;
  };

  nativeBuildInputs = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    anyio
    authlib
    beautifulsoup4
    dateparser
    defusedxml
    django
    fastapi
    google-auth
    # gpt4all
    gunicorn
    httpx
    itsdangerous
    jinja2
    langchain
    lxml
    openai
    openai-whisper
    pgvector
    pillow
    psycopg2
    pydantic
    pymupdf
    python-multipart
    pyyaml
    # rapidocr-onnxruntime
    requests
    rich
    schedule
    sentence-transformers
    stripe
    tenacity
    tiktoken
    torch
    transformers
    tzdata
    uvicorn
  ];

  nativeCheckInputs = with python3.pkgs; [
    freezegun
    factory-boy
    pytest-xdist
    trio
    psutil
    pytest-django
    pytestCheckHook
  ] ++ [
    (postgresql.withPackages (p: with p; [ pgvector ]))
    postgresqlTestHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "khoj"
  ];

  disabledTests = [
    # Tests require network access
    "test_different_user_data_not_accessed"
    "test_get_api_config_types"
    "test_get_configured_types_via_api"
    "test_image_metadata"
    "test_image_search"
    "test_image_search_by_filepath"
    "test_image_search_query_truncated"
    "test_index_update"
    "test_index_update_with_no_auth_key"
    "test_notes_search"
    "test_notes_search_with_exclude_filter"
    "test_notes_search_with_include_filter"
    "test_parse_html_plaintext_file"
    "test_regenerate_index_with_new_entry"
    "test_regenerate_with_github_fails_without_pat"
    "test_regenerate_with_invalid_content_type"
    "test_regenerate_with_valid_content_type"
    "test_search_for_user2_returns_empty"
    "test_search_with_invalid_auth_key"
    "test_search_with_invalid_content_type"
    "test_search_with_no_auth_key"
    "test_search_with_valid_content_type"
    "test_text_index_same_if_content_unchanged"
    "test_text_indexer_deletes_embedding_before_regenerate"
    "test_text_search"
    "test_text_search_setup_batch_processes"
    "test_update_with_invalid_content_type"
    "test_user_no_data_returns_empty"

    # Tests require rapidocr-onnxruntime
    "test_multi_page_pdf_to_jsonl"
    "test_single_page_pdf_to_jsonl"
    "test_ocr_page_pdf_to_jsonl"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_conversation_utils.py"
  ];

  meta = with lib; {
    description = "Natural Language Search Assistant for your Org-Mode and Markdown notes, Beancount transactions and Photos";
    homepage = "https://github.com/debanjum/khoj";
    changelog = "https://github.com/debanjum/khoj/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ dit7ya ];
    broken = true; # last successful build 2024-01-10
  };
}
