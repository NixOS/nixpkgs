{ runtimeShell, writeReferencesToFile, runCommand
, nix, lib
}:

{ cfg }:
/* Accepts these values from the NixOS nix.* options. Refer to the
  configuration.nix man page or https://nixos.org/nixos/options.html#nix. for futher details
  - extraOptions
  - maxJobs
  - buildCores
  - useSandbox
  - sandboxPaths
  - binaryCaches
  - trustedBinaryCaches
  - binaryCachePublicKeys
  - autoOptimiseStore
  - requireSignedBinaryCaches
  - trustedUsers
  - allowedUsers
  - distributedBuilds
  - checkConfig
*/

with lib;

let
  # In Nix < 2.0, If we're using sandbox for builds, then provide
  # /bin/sh in the sandbox as a bind-mount to bash. This means we
  # also need to include the entire closure of bash. Nix >= 2.0
  # provides a /bin/sh by default.
  sh = runtimeShell;
  binshDeps = writeReferencesToFile sh;

  isNix20 = versionAtLeast (getVersion nix.out) "2.0pre";
in
  runCommand "nix.conf" { extraOptions = cfg.extraOptions; } (''
    ${optionalString (!isNix20) ''
      extraPaths=$(for i in $(cat ${binshDeps}); do if test -d $i; then echo $i; fi; done)
    ''}
    cat > $out <<END
    # WARNING: this file is generated from the nix.* options in
    # your NixOS configuration, typically
    # /etc/nixos/configuration.nix.  Do not edit it!
    build-users-group = nixbld
    ${if isNix20 then "max-jobs" else "build-max-jobs"} = ${toString cfg.maxJobs}
    ${if isNix20 then "cores" else "build-cores"} = ${toString cfg.buildCores}
    ${if isNix20 then "sandbox" else "build-use-sandbox"} = ${if (builtins.isBool cfg.useSandbox) then boolToString cfg.useSandbox else cfg.useSandbox}
    ${if isNix20 then "extra-sandbox-paths" else "build-sandbox-paths"} = ${toString cfg.sandboxPaths} ${optionalString (!isNix20) "/bin/sh=${sh} $(echo $extraPaths)"}
    ${if isNix20 then "substituters" else "binary-caches"} = ${toString cfg.binaryCaches}
    ${if isNix20 then "trusted-substituters" else "trusted-binary-caches"} = ${toString cfg.trustedBinaryCaches}
    ${if isNix20 then "trusted-public-keys" else "binary-cache-public-keys"} = ${toString cfg.binaryCachePublicKeys}
    auto-optimise-store = ${boolToString cfg.autoOptimiseStore}
    ${if isNix20 then ''
      require-sigs = ${if cfg.requireSignedBinaryCaches then "true" else "false"}
    '' else ''
      signed-binary-caches = ${if cfg.requireSignedBinaryCaches then "*" else ""}
    ''}
    trusted-users = ${toString cfg.trustedUsers}
    allowed-users = ${toString cfg.allowedUsers}
    ${optionalString (isNix20 && !cfg.distributedBuilds) ''
      builders =
    ''}
    $extraOptions
    END
  '' + optionalString cfg.checkConfig ''
    echo "Checking that Nix can read nix.conf..."
    ln -s $out ./nix.conf
    NIX_CONF_DIR=$PWD ${nix}/bin/nix show-config >/dev/null
  '')
