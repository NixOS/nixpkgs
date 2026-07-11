{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  semgrep-core,

  # check tools
  git,
  pytestCheckHook,

  # python runtime dependencies
  attrs,
  boltons,
  click,
  click-option-group,
  colorama,
  defusedxml,
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
  semgrepBinPath = lib.makeBinPath [ semgrep-core ];
in
buildPythonPackage rec {
  format = "setuptools";
  pname = "semgrep";
  inherit (common) version;
  src = fetchFromGitHub {
    owner = "semgrep";
    repo = "semgrep";
    rev = "v${version}";
    hash = common.srcHash;
  };

  # prepare a subset of the submodules as we only need a handful
  # and there are many many submodules total
  postPatch =
    (lib.concatStringsSep "\n" (
      lib.mapAttrsToList (path: submodule: ''
        # substitute ${path}
        # remove git submodule placeholder
        rm -r ${path}
        # link submodule
        ln -s ${submodule}/ ${path}
      '') passthru.submodulesSubset
    ))
    + ''
      cd cli
    '';

  # tell cli/setup.py to not copy semgrep-core into the result
  # this means we can share a copy of semgrep-core and avoid an issue where it
  # copies the binary but doesn't retain the executable bit
  env.SEMGREP_SKIP_BIN = true;

  pythonRelaxDeps = [
    "boltons"
    "glom"
  ];

  dependencies = [
    attrs
    boltons
    click
    click-option-group
    colorama
    defusedxml
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

  doCheck = true;

  nativeCheckInputs = [
    git
    pytestCheckHook

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
  ];

  preCheck = ''
    # tests need a home directory
    export HOME="$(mktemp -d)"

    # tests need access to `semgrep-core`
    export OLD_PATH="$PATH"
    export PATH="$PATH:${semgrepBinPath}"
  '';

  postCheck = ''
    export PATH="$OLD_PATH"
    unset OLD_PATH
  '';

  # since we stop cli/setup.py from finding semgrep-core and copying it into
  # the result we need to provide it on the PATH
  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${semgrepBinPath})
  '';

  postInstall = ''
    chmod +x $out/bin/{,py}semgrep
  '';

  passthru = {
    inherit common semgrep-core;
    submodulesSubset = lib.mapAttrs (k: args: fetchFromGitHub args) common.submodules;
    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = common.meta.description + " - cli";
    inherit (semgrep-core.meta) platforms;
  };
}
