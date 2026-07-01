regular@{
  lib,
  boehmgc,
  aws-sdk-cpp,
  fetchFromGitHub,
  pkgs,
  curl,
}:

{
  scopeFunction = scope: {
    boehmgc = regular.boehmgc.override {
      enableLargeConfig = true;

      # Increase the initial mark stack size to avoid stack overflows, since these inhibit parallel
      # marking (see `GC_mark_some()` in `mark.c`).
      #
      # Run Nix with `GC_PRINT_STATS=1` set to see if the mark stack is too small.
      # Look for messages such as `Mark stack overflow`, `No room to copy back mark stack`, and
      # `Grew mark stack to ... frames`.
      initialMarkStackSize = 1048576;
    };

    aws-sdk-cpp = regular.aws-sdk-cpp.override {
      # Nix only needs these AWS APIs.
      apis = [
        "identity-management"
        "s3"
        "transfer"
      ];

      # Don't use AWS' custom memory management.
      customMemoryManagement = false;

      # only a stripped down version is built which takes a lot less resources to build
      requiredSystemFeatures = [ ];
    };

    # curl_multi_wakeup is busted since https://github.com/NixOS/nixpkgs/pull/525953 and missed the wakeup (seems like) on first download enqueue?
    curl = curl.overrideAttrs (prevAttrs: {
      patches = lib.filter (
        patch: !lib.strings.hasSuffix "fix-wakeup-consumption.patch" patch
      ) prevAttrs.patches;
    });
  };
}
