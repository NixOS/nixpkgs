{ nixpkgs, pkgs }:

with pkgs;

runCommand "nixpkgs-metrics"
  { nativeBuildInputs = with pkgs.lib; map getBin [ nix time jq ];
    requiredSystemFeatures = [ "benchmark" ];
  }
  ''
    export NIX_DB_DIR=$TMPDIR
    export NIX_STATE_DIR=$TMPDIR
    nix-store --init

    mkdir -p $out/nix-support
    touch $out/nix-support/hydra-build-products

    run() {
      local name="$1"
      shift

      echo "running $@"
      NIX_SHOW_STATS=1 time -o stats-time "$@" 2>stats-nix
      sed '/^warning:/d' -i stats-nix

      cat stats-nix; echo; cat stats-time; echo

      x=$(jq '.cpuTime' < stats-nix)
      [[ -n $x ]] || exit 1
      echo "$name.time $x s" >> $out/nix-support/hydra-metrics

      x=$(sed -e 's/.* \([0-9]\+\)maxresident.*/\1/ ; t ; d' < stats-time)
      [[ -n $x ]] || exit 1
      echo "$name.maxresident $x KiB" >> $out/nix-support/hydra-metrics

      # nix-2.2 also outputs .symbols.bytes but that wasn't summed originally
      # https://github.com/NixOS/nix/pull/2392/files#diff-8e6ba8c21672fc1a5f6f606e1e101c74L1762
      x=$(jq '[.envs,.list,.values,.sets] | map(.bytes) | add' < stats-nix)
      [[ -n $x ]] || exit 1
      echo "$name.allocations $x B" >> $out/nix-support/hydra-metrics

      x=$(jq '.values.number' < stats-nix)
      [[ -n $x ]] || exit 1
      echo "$name.values $x" >> $out/nix-support/hydra-metrics
    }

    run nixos.smallContainer nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix \
      -A closures.smallContainer.x86_64-linux --show-trace
    run nixos.kde nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix \
      -A closures.kde.x86_64-linux --show-trace
    run nixos.lapp nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix \
      -A closures.lapp.x86_64-linux --show-trace
    run nix-env.qa nix-env -f ${nixpkgs} -qa
    run nix-env.qaDrv nix-env -f ${nixpkgs} -qa --drv-path --meta --xml

    num=$(nix-env -f ${nixpkgs} -qa | wc -l)
    echo "nix-env.qaCount $num" >> $out/nix-support/hydra-metrics

    # TODO: this has been ignored for some time
    # GC Warning: Bad initial heap size 128k - ignoring it.
    #export GC_INITIAL_HEAP_SIZE=128k
    run nix-env.qaAggressive nix-env -f ${nixpkgs} -qa
    run nix-env.qaDrvAggressive nix-env -f ${nixpkgs} -qa --drv-path --meta --xml

    lines=$(find ${nixpkgs} -name "*.nix" -type f | xargs cat | wc -l)
    echo "loc $lines" >> $out/nix-support/hydra-metrics
  ''
