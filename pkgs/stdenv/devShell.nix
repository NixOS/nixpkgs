{ pkgs }:
{ drv, ... }:

# stdenvDevShell only supports simple derivations, not generalized packages or anything else.
assert drv?drvPath && drv.type or null == "derivation";

# TODO: fork and improve nix-shell logic
(pkgs.buildPackages.writeScriptBin "devShell" ''
  #!${pkgs.buildPackages.runtimeShell}
  ${pkgs.buildPackages.nix}/bin/nix-shell ${builtins.unsafeDiscardOutputDependency drv.drvPath}
'').overrideAttrs (finalAttrs: prevAttrs: {
  passthru = prevAttrs.passthru or {} // {
    shellData = pkgs.runCommandLocal "devShell-data" {
      # inputDerivation can only produce one file without breaking back compat
      # hence, we only use its implementation and improve its interface.
      # TODO: expose the structured attrs files?
      inherit (drv) inputDerivation;
    } ''
      mkdir $out
      cp $inputDerivation $out/environment.sh
    '';
  };
})
