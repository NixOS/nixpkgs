# This is an entrypoint, invoked by the NixOS/nix CI and pkgs.nix.tests
let
  defaultPath =
    if builtins.pathExists ../../../.git
    then
      # worktree
      builtins.fetchGit ../../..
      # or a fixed version, to cache evals when hacking
      # builtins.fetchGit {
      #   url = ../../..;
      #   rev = "f70a4f73be98c64f4ea930f61bcc80df0f7487d7";
      # }
    else ../../..;
in
{ pkgs-path ? defaultPath
, pkgs ? import pkgs-path {}
, lib ? pkgs.lib
, nix ? pkgs.nix
  # shardCount = max-jobs may be most time efficient, but consumes a lot of memory.
  # Using more shards reduces memory usage because of reachable objects that go unused.
  # Using more shards tends to increase the time spent re-evaluating shared values.
  # Anecdata:
  # on a 12-core, max-jobs = 12, mem = 64G machine,
  # 50 shards adds a 10% time overhead compared to 12
  # Est. peak memory at 12 shards: 20 GB
  #                     50 shards: 13 GB
  # These memory measurements were quick and dirty by looking at memory usage
  # graphs on a desktop system, which are noisy, especially because some swap was used.
, shardCount ? 50
, mask ? {}
}:

let
  label = "by-${nix.pname}-${nix.version}";

  attrPaths = import ./all-attrpaths.nix { inherit pkgs-path pkgs lib nix; writePaths = true; };

  # This evaluates all the attribute paths in the Nixpkgs tree, and returns
  # information about them.
  combinedShards = pkgs.runCommand "all-attribute-values-${label}.json" {
    shards = map (shard: shard + "/attrs.json") allShards;
    nativeBuildInputs = [ pkgs.jq ];
    knownIssues = builtins.toJSON mask;
  } ''
    jq -s 'reduce .[] as $item ({}; . * $item)
      + $knownIssues' \
      --argjson knownIssues "$knownIssues" \
      $shards >$out
  '';

  allShards = lib.genList shard shardCount;

  shard = shardIndex:
    pkgs.runCommand "attr-values-shard-${shardIndexToString shardIndex}-of-${toString shardCount}-${label}" {
    nativeBuildInputs = [
      nix
      pkgs.gitMinimal
      pkgs.jq
    ] ++ lib.optional pkgs.stdenv.isLinux pkgs.inotify-tools;
    strictDeps = true;
  }
  ''
    datadir="${nix}/share"
    export TEST_ROOT=$(pwd)/test-tmp
    export HOME=$(mktemp -d)
    export NIX_BUILD_HOOK=
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_STORE_DIR=/nix/store
    export PAGER=cat
    cacheDir=$TEST_ROOT/binary-cache

    nix-store --init

    # cp -r ${pkgs-path}/lib lib
    # cp -r ${pkgs-path}/pkgs pkgs
    # cp -r ${pkgs-path}/default.nix default.nix
    # cp -r ${pkgs-path}/nixos nixos
    # cp -r ${pkgs-path}/maintainers maintainers
    # cp -r ${pkgs-path}/.version .version
    # cp -r ${pkgs-path}/doc doc
    mkdir $out
    nix-instantiate --eval --strict --json ${./all-attributes-eval-shard.nix} \
        --arg shardIndex ${toString shardIndex} \
        --arg shardCount ${toString shardCount} \
        --arg attrPaths 'builtins.fromJSON (builtins.readFile ${attrPaths}/paths.json)' \
        --arg path ${pkgs-path} \
        > $out/attrs.json
  '';

  # Padding is worth the effort because Nix usually schedules in order of name,
  # giving a nice indication of progress.

  toStringPad = size: int:
    let
      s = toString int;
      padding = size - (lib.stringLength s);
    in
      if padding > 0
      then lib.strings.replicate padding "0" + s
      else s;

  shardCountPad = lib.stringLength (toString shardCount);

  # Note that progress counting starts at 1, not 0. E.g. number 50 out of 50.
  shardIndexToString = shardIndex: toStringPad shardCountPad (shardIndex + 1);

in
  combinedShards
