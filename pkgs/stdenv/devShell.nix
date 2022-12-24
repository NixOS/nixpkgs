{ pkgs }:
{ drv, ... }:

# stdenvDevShell only supports simple derivations, not generalized packages or anything else.
assert drv?drvPath && drv.type or null == "derivation";

# TODO: fork and improve nix-shell logic
(pkgs.buildPackages.writeScriptBin "devShell" ''
  #!${pkgs.buildPackages.runtimeShell}

  # TODO replicate in bash
  exec ${pkgs.buildPackages.nix}/bin/nix-shell ${builtins.unsafeDiscardOutputDependency drv.drvPath}

'').overrideAttrs (prevAttrs: {
  buildCommand = ''
    # Write the bin/devShell command
    ${prevAttrs.buildCommand}
    mkdir -p $out

    # environment.sh exposes the environment, but no bash functions
    cp $inputDerivation $out/environment.sh

    # TODO implement this and use it in the devShell command
    #      should this have a different name?
    # setup.sh loads the derivation-like environment variables and stdenv/setup.sh
    echo '# TODO' >$out/setup.sh
  '';
  # TODO not sure if these must be equal; may want to reimplement this, maybe?
  inherit (drv) inputDerivation;
})
