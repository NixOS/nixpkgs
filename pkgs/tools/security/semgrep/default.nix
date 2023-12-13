{ lib
, fetchFromGitHub
, semgrep-core
, buildPythonApplication
, pythonPackages
, pythonRelaxDepsHook

, pytestCheckHook
, git
}:

let
  common = import ./common.nix { inherit lib; };
in
buildPythonApplication rec {
  pname = "semgrep";
  inherit (common) version;
  src = fetchFromGitHub {
    owner = "returntocorp";
    repo = "semgrep";
    rev = "v${version}";
    hash = common.srcHash;
  };

  # prepare a subset of the submodules as we only need a handful
  # and there are many many submodules total
  postPatch = (lib.concatStringsSep "\n" (lib.mapAttrsToList
    (
      path: submodule: ''
        # substitute ${path}
        # remove git submodule placeholder
        rm -r ${path}
        # link submodule
        ln -s ${submodule}/ ${path}
      ''
    )
    passthru.submodulesSubset)) + ''
    cd cli
  '';

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  # tell cli/setup.py to not copy semgrep-core into the result
  # this means we can share a copy of semgrep-core and avoid an issue where it
  # copies the binary but doesn't retain the executable bit
  SEMGREP_SKIP_BIN = true;

  pythonRelaxDeps = [
    "boltons"
    "glom"
  ];

  propagatedBuildInputs = with pythonPackages; [
    attrs
    boltons
    colorama
    click
    click-option-group
    glom
    requests
    rich
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

  postInstall = ''
    chmod +x $out/bin/{,py}semgrep
  '';

  passthru = {
    inherit common;
    submodulesSubset = lib.mapAttrs (k: args: fetchFromGitHub args) common.submodules;
    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = common.meta.description + " - cli";
    inherit (semgrep-core.meta) platforms;
  };
}
