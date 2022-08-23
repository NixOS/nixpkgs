{ lib
, fetchFromGitHub
, callPackage
, semgrep-core
, buildPythonApplication
, pythonPackages

, pytestCheckHook
, git
}:

let
  common = callPackage ./common.nix { };
in
buildPythonApplication rec {
  pname = "semgrep";
  inherit (common) version;
  src = "${common.src}/cli";

  SEMGREP_CORE_BIN = "${semgrep-core}/bin/semgrep-core";

  postPatch = ''
    substituteInPlace setup.py \
      --replace "typing-extensions~=4.2" "typing-extensions" \
      --replace "jsonschema~=3.2" "jsonschema" \
      --replace "boltons~=21.0" "boltons"

    # remove git submodule placeholders
    rm -r ./src/semgrep/{lang,semgrep_interfaces}
    # link submodule dependencies
    ln -s ${common.langsSrc}/ ./src/semgrep/lang
    ln -s ${common.interfacesSrc}/ ./src/semgrep/semgrep_interfaces
  '';

  doCheck = true;
  checkInputs = [ git pytestCheckHook ] ++ (with pythonPackages; [
    pytest-snapshot
    pytest-mock
    pytest-freezegun
    types-freezegun
  ]);
  disabledTests = [
    # requires networking
    "tests/unit/test_metric_manager.py"
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
  ];

  meta = common.meta // {
    description = common.meta.description + " - cli";
  };
}
