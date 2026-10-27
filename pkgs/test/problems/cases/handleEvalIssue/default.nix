{
  nixpkgs ? ../../../../..,
}:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [ ];
    config = {
      checkMeta = true;
      handleEvalIssue = reason: errormsg: builtins.trace "reason: ${reason}, errormsg: ${errormsg}" true;
      problems.matchers = [
        {
          kind = "deprecated";
          handler = "error";
        }
        {
          kind = "removal";
          handler = "error";
        }
      ];
    };
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "a";
  version = "0";
  meta.description = "Some package";
  meta.problems.removal.message = "To be removed.";
  meta.problems.deprecated.message = "To be deprecated.";
}
