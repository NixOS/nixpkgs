{ lib, shell }:
{ drvAttrs, ... }:

assert lib.asserts.assertMsg (
  (baseNameOf drvAttrs.builder) == "bash"
) "devShell attribute is only supported on derivations that use 'bash' as their builder";

let
  sanitize =
    drvAttrs:
    removeAttrs drvAttrs [
      "outputChecks"
      "allowedReferences"
      "allowedRequisites"
      "disallowedReferences"
      "disallowedRequisites"
    ];
in
derivation (
  sanitize drvAttrs
  // {
    name = "${drvAttrs.name}-env";
    args = [
      ./get-env.sh
      shell
    ];
  }
)
// {
  meta = {
    mainProgram = "setup";
  };
  __isDevShell = true;
}
