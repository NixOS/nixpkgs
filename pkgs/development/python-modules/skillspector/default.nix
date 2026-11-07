{
  lib,

  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build
  hatchling,

  # runtime
  boto3,
  httpx,
  langchain-anthropic,
  langchain-aws,
  langchain-core,
  langchain-openai,
  langgraph,
  langgraph-cli,
  langsmith,
  openai,
  pydantic,
  pyyaml,
  rich,
  typer,
  yara-python,
  # optional
  mcp,

  # test
  pytestCheckHook,
  pytest-asyncio,
  pytest-timeout,

  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "skillspector";
  version = "2.10.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "SkillSpector";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yh4QJLgxF5FdepGK8u+qxrxuxDsgbbbhjGNDn1RwFb4=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "typer"
  ];

  dependencies = [
    boto3
    httpx
    langchain-anthropic
    langchain-aws
    langchain-core
    langchain-openai
    langgraph
    langsmith
    openai
    pydantic
    pyyaml
    rich
    typer
    yara-python
  ];

  # not including dev
  optional-dependencies = {
    "mcp" = [
      mcp
    ];

    # meta - hold all the optional dependencies for cli features
    full = lib.flatten (
      lib.attrValues (
        lib.removeAttrs finalAttrs.passthru.optional-dependencies [
          "full" # self
        ]
      )
    );
  };

  pythonImportsCheck = [
    "skillspector"
  ];

  passthru.updateScript = nix-update-script { };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ]
  # include extra cli deps so all the tests run
  ++ finalAttrs.passthru.optional-dependencies.full;

  disabledTestPaths = [
    # avoid unnecessary project release related tests
    "tests/unit/test_create_github_release.py"
    "tests/unit/test_github_release_workflow.py"
  ];

  disabledTests = [
    # this test alone adds around 3m50s/230s
    # without it **all** the tests are done in around 6s
    "test_exact_character_limit_scanned"

    # `_is_private_ip()` calls `socket.getaddrinfo()` to resolve the IP of
    # domains which in the sandbox will incorrectly be recognised as private and
    # fail
    "test_validate_url_host_scp_extracts_github"
    "test_scp_valid_host_clones"
    "test_https_url_unchanged"
    "test_github_url_allowed"
    "test_gitlab_url_allowed"
    "test_raw_githubusercontent_allowed"

    # wants to download file remotely via raw.githubusercontent.com
    "test_download_does_not_follow_redirects"

    # seems to fail to find the cli itself
    # Error while finding module specification for 'skillspector.cli' (PackageNotFoundError: No package metadata was found for skillspector)
    "test_mcp_stdio_initialize_registers_scan_skill"
  ];

  meta = {
    description = "Security scanner for AI agent skills. Detect vulnerabilities, malicious patterns, and security risks";
    longDescription = ''
      Security scanner for AI agent skills (Claude Code, Cursor, and similar).
      Scans skills for vulnerabilities, malicious patterns, and security risks
      before installation.
      Supports Git repos, URLs, zips, and local directories; runs static pattern
      checks and optional LLM semantic analysis; outputs terminal, JSON, and
      Markdown reports with risk scoring.
    '';
    homepage = "https://github.com/NVIDIA/SkillSpector";
    changelog = "https://github.com/NVIDIA/SkillSpector/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "skillspector";
  };
})
