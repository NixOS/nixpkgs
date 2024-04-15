{
  fetchFromGitHub,
  jq,
  lib,
  nix,
  nixVersions,
  nix-diff,
  pkgs,
  pkgs-path ? builtins.fetchGit ../../../../..,
  runCommand,
}:

let
  knownIssues = {
    # pkgs-lib-formats-tests.drv has floats with different number of digits compared to Nix 2.3
    "tests.pkgs-lib" = "KNOWN-UNREPRODUCIBLE";
    # options.json, used in the docs, also a float rendered to string
    "nixos-install-tools" = "KNOWN-UNREPRODUCIBLE";
    # same options.json
    "tests.nixos-functions.nixos-test" = "KNOWN-UNREPRODUCIBLE";
  };

  evalAllAttributes = nix: mask: import ../../../../test/eval/all-attributes.nix { inherit pkgs nix mask; };

  # This is the Nix package to all others are compared against.
  #
  # We didn't pick Nix 2.3 because it had different logic for printing floats,
  # and it's the only currently packaged Nix that has the old behavior.
  # By making 2.13 the reference version, we can check all attributes without
  # making any exceptions (knownIssues above). Updates of 2.3 will be tested
  # against 2.13, and vice versa.
  # Thus equivalence to 2.3, the minimum version currently supported by Nixpkgs,
  # is inferred by transitivity; not directly.
  referenceNix = nixVersions.nix_2_13.overrideAttrs (o: {
    # This runs in the sandbox, without network access, so we don't need to
    # care about vulnerabilities. The host Nix is responsible for security;
    # not this one.
    meta = o.meta // { knownVulnerabilities = []; };
  });

  otherNix =
    if nix.version != referenceNix.version
    then referenceNix
    else nixVersions.stable;

  # TODO (nix-diff > 1.0.20): Remove this override
  nix-diff_master = nix-diff.overrideAttrs (o: {
    patches = [];
    version = "1.0.21pre-f31e0c1";
    src = fetchFromGitHub {
      owner = "Gabriella439";
      repo = "nix-diff";
      rev = "f31e0c1b5cc21b21e266d823ddca4ab2bce15967";
      hash = "sha256-36eiphOwAivbfCHKgfUTu7SKpeXii4/2DgAhAG1ifxQ=";
    };
    prePatch = "";
  });

  evalAndCompareAllAttributes =
    let
      hasKnownIssues = ! lib.versionAtLeast nix.version "2.13"; # Not sure which version; could be older than 2.13
      mask = lib.optionalAttrs hasKnownIssues knownIssues;
    in
      runCommand "compare-attributes-nix-${nix.version}-vs-${otherNix.version}" {
        expected = evalAllAttributes otherNix mask;
        nix_expected = otherNix;
        actual = evalAllAttributes nix mask;
        nix_actual = nix;
        path = pkgs-path;
        nativeBuildInputs = [
          nix
          pkgs.gitMinimal
          jq
          nix-diff_master
        ];
        strictDeps = true;
      }
      ''
        export TEST_ROOT=$(pwd)/test-tmp
        export HOME=$(mktemp -d)
        export NIX_BUILD_HOOK=
        export NIX_CONF_DIR=$TEST_ROOT/etc
        export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
        export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
        export NIX_STATE_DIR=$TEST_ROOT/var/nix
        export NIX_REMOTE=$TEST_ROOT/store
        export NIX_STORE_DIR=/nix/store
        export PAGER=cat
        cacheDir=$TEST_ROOT/binary-cache

        nix-store --init

        mkdir -p $out/diffs
        nix-instantiate --eval --strict --json ${./compareEval-reinstantiate.nix} \
            --arg expected "builtins.fromJSON (builtins.readFile $expected)" \
            --arg actual "builtins.fromJSON (builtins.readFile $actual)" \
            --arg path $path \
            --show-trace \
            > $out/comparison.json
        (
          # echo script:
          # jq -r .commands $out/comparison.json | cat -n
          eval "set -euo pipefail; $(jq -r .commands $out/comparison.json)"
        )
        cp -r $NIX_REMOTE $out/store
        (
          # This configures your shell environment so that Nix uses the store
          # containing the instantiated derivations.
          echo "export NIX_STORE_DIR='$NIX_STORE_DIR'"
          echo "export NIX_REMOTE='$out/store?read-only=true'"
        ) >$out/env.sh

        cat <<<"$out/store?read-only=true" >$out/store-uri
      '';

  testEvalAllAttributes =
    runCommand "check-${evalAndCompareAllAttributes.name}" {
      comparison = evalAndCompareAllAttributes;
      nativeBuildInputs = [ jq ];
    } ''
      if [[ -e $comparison/failed ]]; then
        echo "Found differences:"
        jq -r .report $comparison/comparison.json
        echo "Diffs are available in:"
        echo "    ls $comparison/diffs"
        echo "Store files can be manually inspected at:"
        echo "    $comparison/store"
        echo "Load store environment:"
        echo "    source $comparison/env.sh"
        echo "Use store URI:"
        echo "    nix --store $(cat $comparison/store-uri) --extra-experimental-features read-only-local-store"
        echo "nix-diff:"
        echo "    NIX_REMOTE=$(sed -e 's/?.*//' < $comparison/store-uri) ${nix-diff_master}/bin/nix-diff"
        exit 1;
      else
        mkdir $out
      fi
    '';
in
  testEvalAllAttributes
