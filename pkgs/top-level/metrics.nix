{ nixpkgs, pkgs }:

with pkgs;

runCommand "nixpkgs-metrics"
  { buildInputs = [ nix time ];
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
      NIX_SHOW_STATS=1 time "$@" > /dev/null 2> stats

      cat stats

      x=$(sed -e 's/.*time elapsed: \([0-9\.]\+\).*/\1/ ; t ; d' stats)
      [[ -n $x ]] || exit 1
      echo "$name.time $x s" >> $out/nix-support/hydra-metrics

      x=$(sed -e 's/.* \([0-9]\+\)maxresident.*/\1/ ; t ; d' stats)
      [[ -n $x ]] || exit 1
      echo "$name.maxresident $x KiB" >> $out/nix-support/hydra-metrics

      x=$(sed -e 's/.*total allocations: \([0-9]\+\) bytes.*/\1/ ; t ; d' stats)
      [[ -n $x ]] || exit 1
      echo "$name.allocations $x B" >> $out/nix-support/hydra-metrics

      x=$(sed -e 's/.*values allocated: \([0-9]\+\) .*/\1/ ; t ; d' stats)
      [[ -n $x ]] || exit 1
      echo "$name.values $x" >> $out/nix-support/hydra-metrics
    }

    run nixos.smallContainer nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.smallContainer.x86_64-linux
    run nixos.kde nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.kde.x86_64-linux
    run nixos.lapp nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.lapp.x86_64-linux
    run nix-env.qa nix-env -f ${nixpkgs} -qa
    run nix-env.qaDrv nix-env -f ${nixpkgs} -qa --drv-path --meta --xml

    export GC_INITIAL_HEAP_SIZE=128k
    run nix-env.qaAggressive nix-env -f ${nixpkgs} -qa
    run nix-env.qaDrvAggressive nix-env -f ${nixpkgs} -qa --drv-path --meta --xml

    lines=$(find ${nixpkgs} -name "*.nix" -type f | xargs cat | wc -l)
    echo "loc $lines" >> $out/nix-support/hydra-metrics
  ''
