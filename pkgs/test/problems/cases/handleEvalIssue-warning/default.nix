{
  nixpkgs ? ../../../../..,
}:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [ ];
    config = {
      checkMeta = true;
      handleEvalIssue = reason: msg: builtins.trace "reason: ${reason}, msg: ${msg}" true;
    };
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "a";
  version = "0";
  meta.description = "Some package";
  meta.problems.removal.message = "To be removed.";
}
