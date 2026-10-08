{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  semgrep-core,

  # check tools
  addBinToPathHook,
  gitMinimal,
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # python runtime dependencies
  attrs,
  boltons,
  click,
  click-option-group,
  colorama,
  defusedxml,
  exceptiongroup,
  glom,
  jsonschema,
  mcp,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-instrumentation-requests,
  opentelemetry-instrumentation-threading,
  opentelemetry-sdk,
  packaging,
  peewee,
  python-lsp-jsonrpc,
  requests,
  rich,
  ruamel-yaml,
  semantic-version,
  tomli,
  tqdm,
  typing-extensions,
  urllib3,
  wcmatch,

  # python check dependencies
  flaky,
  pytest-asyncio,
  pytest-freezegun,
  pytest-mock,
  pytest-snapshot,
  requests-mock,
  types-freezegun,
}:

# testing locally post build:
# ./result/bin/semgrep scan --metrics=off --config 'r/generic.unicode.security.bidi.contains-bidirectional-characters'

let
  common = import ./common.nix { inherit lib; };
in
buildPythonPackage (finalAttrs: {
  pname = "semgrep";
  inherit (common) version;
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "semgrep";
    repo = "semgrep";
    tag = "v${finalAttrs.version}";
    hash = common.srcHash;
  };

  sourceRoot = "${finalAttrs.src.name}/cli";

  # prepare a subset of the submodules as we only need a handful
  # and there are many many submodules total
  postPatch =
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        path: submodule:
        let
          path' = lib.removePrefix "cli/" path;
        in
        ''
          # substitute ${path'}
          # remove git submodule placeholder
          rm -r ${path'}
          # link submodule
          ln -s ${submodule}/ ${path'}
        ''
      ) finalAttrs.passthru.submodulesSubset
    )
    # hardcode the path to the shared `semgrep-core` binary so that it does not
    # need to be copied into the wheel nor be present on PATH at runtime.
    # There are two independent lookups: one in the library and one in the CLI
    # entrypoint (which execs semgrep-core directly).
    + ''
      substituteInPlace src/semgrep/semgrep_core.py \
        --replace-fail \
          'ret = compute_executable_path("semgrep-core")' \
          'ret = "${lib.getExe semgrep-core}"'

      substituteInPlace src/semgrep/console_scripts/entrypoint.py \
        --replace-fail \
          'path = shutil.which(core)' \
          'path = "${lib.getExe semgrep-core}" if not pro else shutil.which(core)'
    '';

  # tell cli/setup.py to not copy semgrep-core into the result
  # this means we can share a copy of semgrep-core and avoid an issue where it
  # copies the binary but doesn't retain the executable bit
  env.SEMGREP_SKIP_BIN = true;

  pythonRelaxDeps = [
    "boltons"
    "click"
    "exceptiongroup"
    "glom"
    "jsonschema"
    "mcp"
    "opentelemetry-api"
    "opentelemetry-exporter-otlp-proto-http"
    "opentelemetry-sdk"
    "wcmatch"
  ];
  dependencies = [
    attrs
    boltons
    click
    click-option-group
    colorama
    defusedxml
    exceptiongroup
    glom
    jsonschema
    mcp
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-instrumentation-requests
    opentelemetry-instrumentation-threading
    opentelemetry-sdk
    packaging
    peewee
    python-lsp-jsonrpc
    requests
    rich
    ruamel-yaml
    semantic-version
    tomli
    tqdm
    typing-extensions
    urllib3
    wcmatch
  ];

  nativeCheckInputs = [
    addBinToPathHook
    gitMinimal
    pytestCheckHook
    writableTmpDirAsHomeHook

    flaky
    pytest-asyncio
    pytest-freezegun
    pytest-mock
    pytest-snapshot
    requests-mock
    types-freezegun
  ];

  disabledTestPaths = [
    "tests/default/e2e"
    "tests/default/e2e-other"
    "tests/default/e2e-pysemgrep"
    "tests/default/mcp"
  ];

  disabledTests = [
    # requires .git directory
    "clean_project_url"
    # doesn't start flaky plugin correctly
    "test_debug_performance"
    # requires networking
    "test_parse_exclude_rules_auto"
    # requires networking
    "test_send"
    # many child tests require networking to download files
    "TestConfigLoaderForProducts"
    # require networking (pro install metrics are sent to semgrep.dev)
    "test_install_command_download_error_records_download_reason"
    "test_install_command_metrics_off"
    "test_install_command_sends_failure_metrics"
    "test_install_command_sends_metrics_when_logged_in"
    "test_run_install_success_records_outcome"
    "test_run_install_version_check_failure_records_error"
  ];

  passthru = {
    inherit common semgrep-core;
    submodulesSubset = lib.mapAttrs (_: args: fetchFromGitHub args) common.submodules;
    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = common.meta.description + " - cli";
    inherit (semgrep-core.meta) platforms;
  };
})
