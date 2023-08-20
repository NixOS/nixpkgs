{ lib
, stdenv
, fetchFromGitHub
, python3
, qt6
}:

python3.pkgs.buildPythonApplication rec {
  pname = "khoj";
  version = "0.11.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "khoj-ai";
    repo = "khoj";
    rev = version;
    hash = "sha256-QDyWU5b2d/Cf3Mrh3R0EsSU4r+auu02ahEkirSIp2JA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "aiohttp == 3.8.4" "aiohttp" \
      --replace "bs4 >= 0.0.1" "beautifulsoup4" \
      --replace "defusedxml == 0.7.1" ""defusedxml"" \
      --replace "fastapi == 0.77.1" "fastapi" \
      --replace "jinja2 == 3.1.2" "jinja2" \
      --replace "pillow == 9.3.0" "pillow" \
      --replace "pydantic >= 1.10.10" "pydantic" \
      --replace "pypdf >= 3.9.0" "pypdf" \
      --replace "pyyaml == 6.0" "pyyaml" \
      --replace "rich >= 13.3.1" "rich" \
      --replace "schedule == 1.1.0" "schedule" \
      --replace "sentence-transformers == 2.2.2" "sentence-transformers" \
      --replace "uvicorn == 0.17.6" "uvicorn" \
      --replace '"pyside6 >= 6.5.1",' ""
  '';

  nativeBuildInputs = with python3.pkgs; [
    hatch-vcs
    hatchling
  ] ++ (with qt6; [
    wrapQtAppsHook
  ]);

  buildInputs = lib.optionals stdenv.isLinux [
    qt6.qtwayland
  ] ++ lib.optionals stdenv.isDarwin [
    qt6.qtbase
  ];

  env = {
    SETUPTOOLS_SCM_PRETEND_VERSION = version;
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    beautifulsoup4
    dateparser
    defusedxml
    fastapi
    gpt4all
    jinja2
    langchain
    openai
    pillow
    pydantic
    pypdf
    pyside6
    pyyaml
    requests
    rich
    schedule
    sentence-transformers
    tenacity
    tiktoken
    torch
    transformers
    uvicorn
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    dev = [
      black
      khoj-assistant
      mypy
      pre-commit
    ];
    test = [
      factory-boy
      freezegun
      pytest
      trio
    ];
  };

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    freezegun
    faker
    pytest-factoryboy
  ];

  # The tests/test_conversation_utils.py file tries to connect to the internet
  # before running tests so adding the tests in disabledTests doesn't work
  preCheck = ''
    export HOME=$(mktemp -d)

    rm tests/test_conversation_utils.py
  '';

  pythonImportsCheck = [
    "khoj"
  ];

  disabledTests = [
    # Tests require network access
    "test_search_with_valid_content_type"
    "test_update_with_valid_content_type"
    "test_regenerate_with_valid_content_type"
    "test_image_search"
    "test_notes_search"
    "test_notes_search_with_only_filters"
    "test_notes_search_with_include_filter"
    "test_notes_search_with_exclude_filter"
    "test_image_metadata"
    "test_image_search"
    "test_image_search_query_truncated"
    "test_image_search_by_filepath"
    "test_asymmetric_setup_with_missing_file_raises_error"
    "test_asymmetric_setup_with_empty_file_raises_error"
    "test_asymmetric_reload"
    "test_asymmetric_setup"
    "test_asymmetric_search"
    "test_entry_chunking_by_max_tokens"
    "test_incremental_update"
    "test_search_with_invalid_content_type"
    "test_update_with_invalid_content_type"
    "test_regenerate_with_invalid_content_type"
    "test_update_with_github_fails_without_pat"
    "test_regenerate_with_github_fails_without_pat"
    "test_get_configured_types_via_api"
    "test_get_configured_types_with_only_plugin_content_config"
    "test_get_configured_types_with_no_plugin_content_config"
    "test_text_search_setup_with_missing_file_raises_error"
    "test_text_search_setup_with_empty_file_raises_error"
    "test_text_search_setup"
    "test_text_index_same_if_content_unchanged"
    "test_text_search"
    "test_regenerate_index_with_new_entry"
    "test_update_index_with_duplicate_entries_in_stable_order"
    "test_update_index_with_deleted_entry"
    "test_update_index_with_new_entry"
  ];

  meta = with lib; {
    changelog = "https://github.com/khoj-ai/khoj/releases/tag/${version}";
    description = "An AI personal assistant for your digital brain";
    homepage = "https://khoj.dev/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
