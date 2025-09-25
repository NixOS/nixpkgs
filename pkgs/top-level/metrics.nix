{ nixpkgs, pkgs }:

let
  inherit (pkgs) lib stdenvNoCC;
  evalSystem = "x86_64-linux";
in

stdenvNoCC.mkDerivation {
  name = "nixpkgs-metrics";

  # Use structured attrs to pass in relevant information.
  __structuredAttrs = true;
  inherit evalSystem nixpkgs;

  outputs = [
    "out"
    "raw"
  ];

  nativeBuildInputs = map lib.getBin [
    pkgs.nixVersions.latest
    pkgs.time
    pkgs.jq
  ];

  # see https://github.com/NixOS/nixpkgs/issues/52436
  #requiredSystemFeatures = [ "benchmark" ]; # dedicated `t2a` machine, by @vcunat

  # Required because this derivation doesn't have a `src`.
  dontUnpack = true;

  configurePhase = ''
    runHook preConfigure

    export NIX_STORE_DIR=$TMPDIR/store
    export NIX_STATE_DIR=$TMPDIR/state
    export NIX_PAGER=
    nix-store --init

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    release="$nixpkgs/nixos/release.nix"

    run() {
      local name="$1"
      shift

      echo "running $@"

      mkdir -p "metrics/$name"
      local output="metrics/$name/output"
      local nix_stats="metrics/$name/nix-stats.json"
      local time_stats="metrics/$name/time-stats.json"

      NIX_SHOW_STATS=1 NIX_SHOW_STATS_PATH="$nix_stats" command time -o "$time_stats" -- "$@" > "$output"

      # Show the Nix statistics and the `time` statistics.
      echo "Nix statistics for $@"
      jq . "$nix_stats"
      echo
      echo "Time statistics for $@"
      jq . "$time_stats"
      echo

      cpuTime="$(jq '.cpuTime' < "$nix_stats")"
      [[ -n $cpuTime ]] || exit 1
      echo "$name.time $cpuTime s" >> hydra-metrics

      maxresident="$(jq '.max_resident_set_kb' < "$time_stats")"
      [[ -n $maxresident ]] || exit 1
      echo "$name.maxresident $maxresident KiB" >> hydra-metrics

      # Nix also outputs `.symbols.bytes` but since that wasn't summed originally, we don't count it here.
      allocations="$(jq '[.envs,.list,.values,.sets] | map(.bytes) | add' < "$nix_stats")"
      [[ -n $allocations ]] || exit 1
      echo "$name.allocations $allocations B" >> hydra-metrics

      values="$(jq '.values.number' < "$nix_stats")"
      [[ -n $values ]] || exit 1
      echo "$name.values $values" >> hydra-metrics
    }

    run nixos.smallContainer nix-instantiate --option eval-system "$evalSystem" --dry-run "$release" -A closures.smallContainer.x86_64-linux --show-trace --no-gc-warning
    run nixos.kde nix-instantiate --option eval-system "$evalSystem" --dry-run "$release" -A closures.kde.x86_64-linux --show-trace --no-gc-warning
    run nixos.lapp nix-instantiate --option eval-system "$evalSystem" --dry-run "$release" -A closures.lapp.x86_64-linux --show-trace --no-gc-warning
    run nix-env.qa nix-env --option eval-system "$evalSystem" -f "$nixpkgs" -qa
    run nix-env.qaDrv nix-env --option eval-system "$evalSystem" -f "$nixpkgs" -qa --drv-path --meta --json

    # It's slightly unclear which of the set to track: qaCount, qaCountDrv, qaCountBroken.
    num="$(wc -l < metrics/nix-env.qa/output)"
    echo "nix-env.qaCount $num" >> hydra-metrics
    qaCountDrv="$(jq -r 'reduce (.[].drvPath? // empty) as $d (0; .+1)' metrics/nix-env.qaDrv/output)"
    numBroken="$((num - $qaCountDrv))"
    echo "nix-env.qaCountBroken $numBroken" >> hydra-metrics

    lines="$(find "$nixpkgs" -name "*.nix" -type f -print0 | xargs -0 cat | wc -l)"
    echo "loc $lines" >> hydra-metrics

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/nix-support
    touch $out/nix-support/hydra-build-products
    mv hydra-metrics $out/nix-support/hydra-metrics

    # Save and compress the raw output
    mv metrics $raw
    xz -v $raw/*/output

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
      | `nix-env.qaDrv` | `nix-env -f ${nixpkgs} -qa --drv-path --meta --json` |
      | `nix-env.qa` | `nix-env -f ${nixpkgs} -qa` |
      | `nixos.kde` | `nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.kde.x86_64-linux --show-trace` |
      | `nixos.lapp` | `nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.lapp.x86_64-linux --show-trace` |
      | `nixos.smallContainer` | `nix-instantiate --dry-run ${nixpkgs}/nixos/release.nix -A closures.smallContainer.x86_64-linux --show-trace`|

      ## Allocations performed (in bytes)

      This counts `envs.bytes`, `list.bytes`, `values.bytes`, and `sets.bytes` from the Nix statistics.

      - [nix-env.qa.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qa.allocations)
      - [nix-env.qaDrv.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrv.allocations)
      - [nixos.kde.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.kde.allocations)
      - [nixos.lapp.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.lapp.allocations)
      - [nixos.smallContainer.allocations](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.smallContainer.allocations)

      ## Maximum resident size (in number of KiB)

      This counts `maxresident` KiB (`%M`) from the `time` command on Linux.

      - [nix-env.qa.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qa.maxresident)
      - [nix-env.qaDrv.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrv.maxresident)
      - [nixos.kde.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.kde.maxresident)
      - [nixos.lapp.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.lapp.maxresident)
      - [nixos.smallContainer.maxresident](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.smallContainer.maxresident)

      ## Time taken (in seconds)

      This counts `cpuTime` as reported in the Nix statistics. On Linux, this resolves to [`getrusage(RUSAGE_SELF)`](https://man7.org/linux/man-pages/man2/getrusage.2.html).

      - [nix-env.qa.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qa.time)
      - [nix-env.qaDrv.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrv.time)
      - [nixos.kde.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.kde.time)
      - [nixos.lapp.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.lapp.time)
      - [nixos.smallContainer.time](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.smallContainer.time)

      ## Number of values

      This counts the total number of values allocated in Nix (see `EvalState::allocValue` in the Nix source code).

      - [nix-env.qa.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qa.values)
      - [nix-env.qaDrv.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nix-env.qaDrv.values)
      - [nixos.kde.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.kde.values)
      - [nixos.lapp.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.lapp.values)
      - [nixos.smallContainer.values](https://hydra.nixos.org/job/nixpkgs/trunk/metrics/metric/nixos.smallContainer.values)
    '';
  };

  # Convince `time` to output in JSON
  env.TIME = builtins.toJSON {
    real_time = "%e";
    user_time = "%U";
    sys_time = "%S";
    cpu_percent = "%P";
    max_resident_set_kb = "%M";
    avg_resident_set_kb = "%t";
    avg_total_mem_kb = "%K";
    avg_data_kb = "%D";
    avg_stack_kb = "%p";
    avg_unshared_data_kb = "%X";
    avg_shared_text_kb = "%Z";
    page_faults_major = "%F";
    page_faults_minor = "%R";
    swaps = "%W";
    context_switches_voluntary = "%c";
    context_switches_involuntary = "%w";
    io_reads = "%I";
    io_writes = "%O";
    signals_received = "%k";
    exit_status = "%x";
    command = "%C";
  };

  # Don't allow aliases anywhere in Nixpkgs for the metrics.
  env.NIXPKGS_CONFIG = builtins.toFile "nixpkgs-config.nix" ''
    {
      allowAliases = false;
    }
  '';
}
