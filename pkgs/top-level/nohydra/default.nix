#
# Usage:
#
#   nix-build pkgs/top-level/nohydra -A release-drvpaths
#   pkgs/top-level/nohydra/instantiate.sh
#   nix-build pkgs/top-level/nohydra -A release --keep-going
#
# Technically you can omit the first command and it will get
# re-executed as part of instantiate.sh, but I prefer to run it
# separately so that the second step (which is the only non
# nix-build step) always runs very quickly.  nix-build gives good
# feedback on its progress.
#
# Why are there three steps?
#
# Short answer: in order to exploit `nix-instantiate` / `nix-build`
# separation, which is the trick to being able to do release builds
# without the Hydra software.
#
# Long answer:
#
# 1. Generating the list of release attrpaths requires a lot of
#    memory; generating the list of release drvpaths requires an
#    even larger amount of memory, and a *huge* amount of
#    processing.  The first command generates both of these
#    (attrpaths and drvpaths).  This is all done inside of a Nix
#    derivation, which ensures that the list depends only on the git
#    HEAD commit-hash, and also that this expensive work isn't done
#    over again unless that commit has changed.
#
# 2. The second command iterates over the list of attrpaths/drvpaths
#    and runs `nix-instantiate` on each attrpath whose drvpath
#    doesn't exist in the local store.  This cannot be done from
#    inside a derivation (at least not without recursive-nix).
#
# 3. The third command builds all the derivations in one massive
#    build.  This is possible because it starts from a list of
#    derivations -- the Nix evaluator (libexpr) does almost no work
#    in the third command.
#

{ lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, pkgs ? import ../../../. { }
, nix ? pkgs.nix
, includeBroken ? false
, enableParallel ? true
, enableCheckMeta ? true
, nixpkgs-gitdir ? ../../../.git
}:

let

  rev = lib.commitIdFromGitRepo nixpkgs-gitdir;
  shortRev = builtins.substring 0 8 rev;
  src = builtins.fetchGit {
    name = "nixpkgs";
    shallow = true;
    inherit rev;
    ref = "HEAD";
    url = nixpkgs-gitdir;
  };

  # Copied from lib/tests/release.nix but changed to ensure that
  # NIX_STORE_DIR is the same inside these derivations as it is
  # outside -- otherwise the drvPaths will be different!
  initialize-nix-store = ''
    datadir="${nix}/share"
    mkdir -p ${builtins.storeDir}
    export TEST_ROOT=$(pwd)/test-tmp
    export HOME=$(mktemp -d)
    export NIX_BUILD_HOOK=
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_STORE_DIR=${builtins.storeDir}
    export PAGER=cat
    cacheDir=$TEST_ROOT/binary-cache
    nix-store --init
  '';

  # This runs serially, on one core.  It is used only if enableParallel=true.
  release-attrpaths-superset = stdenv.mkDerivation {
    pname = "nixpkgs-release-attrpaths-superset";
    version = shortRev;
    inherit src;
    nativeBuildInputs = [ pkgs.nix ];
    buildPhase = ''
      ${initialize-nix-store}
      runHook preBuild
      ${lib.escapeShellArgs [
        "nix-instantiate"
        "--eval"
        "--strict"
        "--json"
        "--readonly-mode"
        "pkgs/top-level/release-attrpaths-superset.nix"
        "-A" "names"
      ]} > release-attrpaths-superset.out;
      runHook postBuild
    '';
    installPhase = ''
      mkdir $out
      mv release-attrpaths-superset.out $out/release-attrpaths-superset.json
    '';
  };

  attrpaths-json = "${release-attrpaths-superset}/release-attrpaths-superset.json";

  buildCommand = [
    "${pkgs.time}/bin/time" "-v"
  ] ++ lib.optionals enableParallel [
    "${pkgs.moreutils}/bin/parallel" "-j" "$NIX_BUILD_CORES"
  ] ++ [
    "${nix}/bin/nix-env"
    "-qaP"
    "--no-name"
    "--drv-path"
    # we can't use "--json" here because it will cause Nix to ignore "--drv-path"
    #   TODO: open an issue in github.com/nixos/nix and link it here
    # also, ${moreutils}/bin/parallel ensures interleaving at \n but json has multiline output.
    "--arg" "checkMeta" (lib.boolToString enableCheckMeta)
    "--arg" "includeBroken" (lib.boolToString includeBroken)
    "-f" "pkgs/top-level/release-outpaths${lib.optionalString enableParallel "-parallel"}.nix"
  ] ++ lib.optionals enableParallel [
    "--arg" "attrPathFile" attrpaths-json
    "--arg" "numChunks" "$NUM_CHUNKS"
    "--arg" "myChunk"
    "--" "$(seq 0 $(($NUM_CHUNKS-1)))"
  ];

  release-drvpaths = stdenv.mkDerivation {
    pname = "nixpkgs-release";
    version = rev;
    inherit src;

    nativeBuildInputs = [ nix ];

    preBuild = lib.optionalString enableParallel ''
      NUM_CHUNKS=$((4*$NIX_BUILD_CORES))
      ${pkgs.jq}/bin/jq -r '.[]' < ${attrpaths-json} > attrpaths
      echo generating $(wc -l < attrpaths) attrpaths in chunks of $NUM_CHUNKS on $NIX_BUILD_CORES cores
    '';

    buildPhase = ''
      runHook preBuild
      ${initialize-nix-store}
      ${toString buildCommand} > release-drvpaths.txt
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out
      mv release-drvpaths.txt $out
    '';
  };

  # uses IFD
  release-map-system-attrpath-drvpath = let
    drvpath-lines = builtins.readFile "${release-drvpaths}/release-drvpaths.txt";  # IFD
    lines = builtins.filter (x: x != [] && x != "") (builtins.split "\n" drvpath-lines);
    line-to-attr = line:
      let
        matches = builtins.split "(  *)" line;
        attrpath-with-system = lib.head matches; # everything before the matched regex
        drvpath = lib.lists.last matches; # everything after the matched regex
        attrpath-split = lib.splitString "." attrpath-with-system;
        system = lib.last attrpath-split;
        attrpath = lib.concatStringsSep "." (lib.take ((lib.length attrpath-split)-1) attrpath-split);
      in {
        "${system}" = {
          "${attrpath}" = drvpath;
        };
      };
  in
    lib.pipe lines [
      (map line-to-attr)
      lib.zipAttrs
      (builtins.mapAttrs (_: lib.attrsets.mergeAttrsList))
    ];

  release-map-attrpath-drvpath =
    release-map-system-attrpath-drvpath.${builtins.currentSystem};

  # uses IFD and is hideously impure
  uninstantiated =
    builtins.listToAttrs
      (lib.filter (x: x!=null)
        (lib.mapAttrsToList
          (attrpath: drvpath:
            if builtins.pathExists drvpath
            then null
            else lib.nameValuePair attrpath drvpath)
          release-map-attrpath-drvpath));

  uninstantiated-attrpaths = lib.mapAttrsToList (attrpath: drvpath: attrpath) uninstantiated;
  uninstantiated-drvpaths = lib.mapAttrsToList (attrpath: drvpath: drvpath) uninstantiated;
  unrealised-drvpaths = lib.pipe release-map-attrpath-drvpath [
    builtins.attrValues
    (map (drvpath:
      let
        imported = import drvpath;
        outpaths = map (output: output.outPath) imported.all;
        any-outpath-unrealised =
          lib.any (outPath:
            # we need to test if the outpath exists without
            # triggering it being built (yet)
            let
              path = builtins.unsafeDiscardStringContext outPath;
              exists = builtins.pathExists path;
            in
              if !exists
              then
                #lib.trace "${path}"
                true
              else false
          )
            outpaths;
      in
        if any-outpath-unrealised
        then drvpath
        else null))
    (lib.filter (x: x!=null))
  ];

  release =
    # thanks to @DavHau for this trick:
    #   https://github.com/nix-how/marsnix/pull/1
    map (drvFile:
      let
        drvFile-discarded = builtins.unsafeDiscardStringContext drvFile;
        imported = import drvFile;

        # some derivations, notably pkgs.sagetex, lack an "out"
        # output.  So we must calculate the name of a valid output;
        # if we fail to do so, we get errors like:
        #
        # error: derivation '/nix/store/k2ihki1cbdz7fma845xpdadnkd3s36zf-sagetex-3.6.1.drv' lacks an 'outputName' attribute
        # error: derivation '/nix/store/9v3nww63p1cagai3nj1cggpc8g9v0jic-sagetex-3.6.1.drv' does not have wanted outputs 'out'
        #
        outputName =
          builtins.unsafeDiscardStringContext
            ((builtins.elemAt imported.all 0).outputName or "out");
      in {
        name = "";
        type = "derivation";
        drvPath = builtins.appendContext "${drvFile-discarded}" {
          "${drvFile-discarded}" = {
            inherit outputs;
          };
        };
        inherit outputName;
      })
      unrealised-drvpaths;

in
{
  inherit
    release-attrpaths-superset
    release-drvpaths
    release-map-system-attrpath-drvpath
    release-map-attrpath-drvpath
    uninstantiated-attrpaths
    unrealised-drvpaths
    release;
}
