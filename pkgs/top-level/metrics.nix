{ nixpkgs, pkgs }:

let
  inherit (pkgs) lib stdenvNoCC;
in

stdenvNoCC.mkDerivation {
  name = "nixpkgs-metrics";

  nativeBuildInputs = map lib.getBin [
    pkgs.nix
    pkgs.time
    pkgs.jq
  ];

  # see https://github.com/NixOS/nixpkgs/issues/52436
  #requiredSystemFeatures = [ "benchmark" ]; # dedicated `t2a` machine, by @vcunat

  unpackPhase = ''
    runHook preUnpack

    export NIX_STORE_DIR=$TMPDIR/store
    export NIX_STATE_DIR=$TMPDIR/state
    export NIX_PAGER=
    nix-store --init

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/nix-support
    touch $out/nix-support/hydra-build-products

    run() {
      local name="$1"
      shift

      echo "running $@"

      case "$name" in
        # Redirect stdout to /dev/null to avoid hitting "Output Limit Exceeded" on Hydra.
        nix-env.qaDrv|nix-env.qaDrvAggressive)
          NIX_SHOW_STATS=1 NIX_SHOW_STATS_PATH=stats-nix time -o stats-time "$@" >/dev/null ;;
        *)
          NIX_SHOW_STATS=1 NIX_SHOW_STATS_PATH=stats-nix time -o stats-time "$@" ;;
      esac

      # Show the Nix statistics and the `time` statistics.
      cat stats-nix
      echo
      cat stats-time
      echo

      cpuTime="$(jq '.cpuTime' < stats-nix)"
      [[ -n $cpuTime ]] || exit 1
      echo "$name.time $cpuTime s" >> $out/nix-support/hydra-metrics

      maxresident="$(sed -e 's/.* \([0-9]\+\)maxresident.*/\1/ ; t ; d' < stats-time)"
      [[ -n $maxresident ]] || exit 1
      echo "$name.maxresident $maxresident KiB" >> $out/nix-support/hydra-metrics

      # Nix also outputs `.symbols.bytes` but since that wasn't summed originally, we don't count it here.
      allocations="$(jq '[.envs,.list,.values,.sets] | map(.bytes) | add' < stats-nix)"
      [[ -n $allocations ]] || exit 1
      echo "$name.allocations $allocations B" >> $out/nix-support/hydra-metrics

      values="$(jq '.values.number' < stats-nix)"
      [[ -n $values ]] || exit 1
      echo "$name.values $values" >> $out/nix-support/hydra-metrics
    }

    run nixos.smallContainer nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.smallContainer.x86_64-linux --show-trace
    run nixos.kde nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.kde.x86_64-linux --show-trace
    run nixos.lapp nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.lapp.x86_64-linux --show-trace
    run nix-env.qa nix-env -f ${nixpkgs} -qa
    run nix-env.qaDrv nix-env -f ${nixpkgs} -qa --drv-path --meta --xml

    # It's slightly unclear which of the set to track: qaCount, qaCountDrv, qaCountBroken.
    num="$(nix-env -f ${nixpkgs} -qa | wc -l)"
    echo "nix-env.qaCount $num" >> $out/nix-support/hydra-metrics
    qaCountDrv="$(nix-env -f ${nixpkgs} -qa --drv-path | wc -l)"
    num="$((num - $qaCountDrv))"
    echo "nix-env.qaCountBroken $num" >> $out/nix-support/hydra-metrics

    # TODO: this has been ignored for some time
    # GC Warning: Bad initial heap size 128k - ignoring it.
    #export GC_INITIAL_HEAP_SIZE=128k
    run nix-env.qaAggressive nix-env -f ${nixpkgs} -qa
    run nix-env.qaDrvAggressive nix-env -f ${nixpkgs} -qa --drv-path --meta --xml

    lines="$(find ${nixpkgs} -name "*.nix" -type f | xargs cat | wc -l)"
    echo "loc $lines" >> $out/nix-support/hydra-metrics

    runHook postInstall
  '';

  meta = {
    description = "Metrics tracked by Hydra about Nixpkgs";
    homepage = "https://hydra.nixos.org/job/nixpkgs/trunk/metrics";
    longDescription = ''
      View the metrics for Nixpkgs evaluation over time at these URLs.

      These are all produced from running `nix` with `NIX_SHOW_STATS=1`.
      See `EvalState::printStatistics` in the Nix source code for the implementation.
      None of these metrics are inherently meaningful on their own.
      Exercise caution in interpreting them as "bad" or "good".

      # Total repository statistics

      - [Lines of code in Nixpkgs](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/loc)
      - [Count of broken packages using `nix-env -qa`](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaCountBroken)
      - [Count of packages using `nix-env -qa`](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaCount)

      # Statistics about representative commands

      These are statistics gathered by running commands against Nixpkgs.

      | Name | Command |
      |------|---------|
      | `nix-env.qaAggressive` | `nix-env -f ${nixpkgs} -qa` |
      | `nix-env.qaDrvAggressive` | `nix-env -f ${nixpkgs} -qa --drv-path --meta --xml` |
      | `nix-env.qaDrv` | `nix-env -f ${nixpkgs} -qa --drv-path --meta --xml` |
      | `nix-env.qa` | `nix-env -f ${nixpkgs} -qa` |
      | `nixos.kde` | `nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.kde.x86_64-linux --show-trace` |
      | `nixos.lapp` | `nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.lapp.x86_64-linux --show-trace` |
      | `nixos.smallContainer` | `nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.smallContainer.x86_64-linux --show-trace`|

      ## Allocations performed (in bytes)

      This counts `envs.bytes`, `list.bytes`, `values.bytes`, and `sets.bytes` from the Nix statistics.

      - [nix-env.qa.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qa.allocations)
      - [nix-env.qaAggressive.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaAggressive.allocations)
      - [nix-env.qaDrv.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrv.allocations)
      - [nix-env.qaDrvAggressive.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrvAggressive.allocations)
      - [nixos.kde.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.kde.allocations)
      - [nixos.lapp.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.lapp.allocations)
      - [nixos.smallContainer.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.smallContainer.allocations)

      ## Maximum resident size (in number of KiB)

      This counts `maxresident` KiB (`%M`) from the `time` command on Linux.

      - [nix-env.qa.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qa.maxresident)
      - [nix-env.qaAggressive.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaAggressive.maxresident)
      - [nix-env.qaDrv.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrv.maxresident)
      - [nix-env.qaDrvAggressive.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrvAggressive.maxresident)
      - [nixos.kde.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.kde.maxresident)
      - [nixos.lapp.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.lapp.maxresident)
      - [nixos.smallContainer.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.smallContainer.maxresident)

      ## Time taken (in seconds)

      This counts `cpuTime` as reported in the Nix statistics. On Linux, this resolves to [`getrusage(RUSAGE_SELF)`](https://man7.org/linux/man-pages/man2/getrusage.2.html).

      - [nix-env.qa.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qa.time)
      - [nix-env.qaAggressive.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaAggressive.time)
      - [nix-env.qaDrv.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrv.time)
      - [nix-env.qaDrvAggressive.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrvAggressive.time)
      - [nixos.kde.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.kde.time)
      - [nixos.lapp.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.lapp.time)
      - [nixos.smallContainer.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.smallContainer.time)

      ## Number of values

      This counts the total number of values allocated in Nix (see `EvalState::allocValue` in the Nix source code).

      - [nix-env.qa.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qa.values)
      - [nix-env.qaAggressive.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaAggressive.values)
      - [nix-env.qaDrv.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrv.values)
      - [nix-env.qaDrvAggressive.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrvAggressive.values)
      - [nixos.kde.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.kde.values)
      - [nixos.lapp.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.lapp.values)
      - [nixos.smallContainer.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.smallContainer.values)
    '';
  };
}
