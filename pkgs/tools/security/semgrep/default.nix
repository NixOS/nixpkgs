{ lib
, fetchFromGitHub
, fetchpatch
, semgrep-core
, buildPythonApplication
, pythonPackages
, pythonRelaxDepsHook

, pytestCheckHook
, git
}:

# testing locally post build:
# ./result/bin/semgrep scan --metrics=off --config 'r/generic.unicode.security.bidi.contains-bidirectional-characters'

let
  common = import ./common.nix { inherit lib; };
  semgrepBinPath = lib.makeBinPath [ semgrep-core ];
in
buildPythonApplication rec {
  pname = "semgrep";
  inherit (common) version;
  src = fetchFromGitHub {
    owner = "semgrep";
    repo = "semgrep";
    rev = "v${version}";
    hash = common.srcHash;
  };

  patches = [
    (fetchpatch {
      name = "fix-test_dump_engine-test-for-nix-store-path.patch";
      url = "https://github.com/semgrep/semgrep/commit/c7553c1a61251146773617f80a2d360e6b6ab3f9.patch";
      hash = "sha256-A3QdL0DDh/pbDpRIBACUie7PEvC17iG4t6qTnmPIwA4=";
    })
  ];

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
    flaky
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
    # many child tests require networking to download files
    "TestConfigLoaderForProducts"
    # doesn't start flaky plugin correctly
    "test_debug_performance"
  ];

  preCheck = ''
    # tests need a home directory
    export HOME="$(mktemp -d)"

    # tests need access to `semgrep-core`
    export OLD_PATH="$PATH"
    export PATH="$PATH:${semgrepBinPath}"

    # we're in cli
    # replace old semgrep with wrapped one
    rm ./bin/semgrep
    ln -s $out/bin/semgrep ./bin/semgrep

    # disabledTestPaths doesn't manage to avoid the e2e tests
    # remove them from pyproject.toml
    # and remove need for pytest-split
    substituteInPlace pyproject.toml \
      --replace '"tests/e2e",' "" \
      --replace '"tests/e2e-pro",' "" \
      --replace 'addopts = "--splitting-algorithm=least_duration"' ""
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
    inherit common;
    submodulesSubset = lib.mapAttrs (k: args: fetchFromGitHub args) common.submodules;
    updateScript = ./update.sh;
  };

  meta = common.meta // {
    description = common.meta.description + " - cli";
    inherit (semgrep-core.meta) platforms;
  };
}
