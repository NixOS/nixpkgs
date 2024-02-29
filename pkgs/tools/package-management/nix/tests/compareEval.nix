{
  lib,
  nix,
  nixVersions,
  pkgs,
  testers,
}:

let
  knownIssues = {
    "tests.pkgs-lib" = "KNOWN-UNREPRODUCIBLE";
    "nixos-install-tools" = "KNOWN-UNREPRODUCIBLE";
    "tests.nixos-functions.nixos-test" = "KNOWN-UNREPRODUCIBLE";
  };

  evalAllAttributes = nix: mask: import ../../../../test/eval/all-attributes.nix { inherit pkgs nix mask; };

  referenceNix = nixVersions.nix_2_13;

  otherNix =
    if nix.version != referenceNix.version
    then referenceNix
    else nixVersions.stable;

  testEvalAllAttributes =
    let
      hasKnownIssues = ! lib.versionAtLeast nix.version referenceNix.version; # Not sure which version; could be older
      mask = lib.optionalAttrs hasKnownIssues knownIssues;
    in
      # TODO: Perform the comparison in jq, so that we get the diff in structured form,
      #       and then if both are paths, re-eval and call nix-diff on it.
      testers.testEqualContents {
        assertion = "The attributes should match.";
        expected = evalAllAttributes otherNix mask;
        actual = evalAllAttributes nix mask;
      };
in
  testEvalAllAttributes
