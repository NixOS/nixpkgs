{ lib
, fetchFromGitHub
, callPackage
, semgrep-core
, buildPythonApplication
, pythonPackages
, pythonRelaxDepsHook

, pytestCheckHook
, git
}:

let
  common = callPackage ./common.nix { };
in
buildPythonApplication rec {
  pname = "semgrep";
  inherit (common) src version;

  postPatch = (lib.concatStringsSep "\n" (lib.mapAttrsToList (
    path: submodule: ''
      # substitute ${path}
      # remove git submodule placeholder
      rm -r ${path}
      # link submodule
      ln -s ${submodule}/ ${path}
    ''
  ) common.submodules)) + ''
    cd cli
  '';

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  # tell cli/setup.py to not copy semgrep-core into the result
  # this means we can share a copy of semgrep-core and avoid an issue where it
  # copies the binary but doesn't retain the executable bit
  SEMGREP_SKIP_BIN = true;

  pythonRelaxDeps = [
    "attrs"
    "boltons"
    "jsonschema"
    "typing-extensions"
  ];

  propagatedBuildInputs = with pythonPackages; [
    attrs
    boltons
    colorama
    click
    click-option-group
    glom
    requests
    ruamel-yaml
    tqdm
    packaging
    jsonschema
    wcmatch
    peewee
    defusedxml
    urllib3
    typing-extensions
    python-lsp-jsonrpc
    tomli
  ];

  doCheck = true;
  nativeCheckInputs = [ git pytestCheckHook ] ++ (with pythonPackages; [
    pytest-snapshot
    pytest-mock
    pytest-freezegun
    types-freezegun
  ]);
  disabledTests = [
    # requires networking
    "test_send"
    # requires networking
    "test_parse_exclude_rules_auto"
  ];
  preCheck = ''
    # tests need a home directory
    export HOME="$(mktemp -d)"

    # disabledTestPaths doesn't manage to avoid the e2e tests
    # remove them from pyproject.toml
    # and remove need for pytest-split
    substituteInPlace pyproject.toml \
      --replace '"tests/e2e",' "" \
      --replace 'addopts = "--splitting-algorithm=least_duration"' ""
  '';

  # since we stop cli/setup.py from finding semgrep-core and copying it into
  # the result we need to provide it on the PATH
  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ semgrep-core ]})
  '';

  passthru = {
    inherit common;
    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = common.meta.description + " - cli";
  };
}
