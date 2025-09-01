regular@{
  lib,
  boehmgc,
  aws-sdk-cpp,
  fetchFromGitHub,
  pkgs,
}:

{
  scopeFunction = scope: {
    boehmgc =
      (regular.boehmgc.override {
        enableLargeConfig = true;
      }).overrideAttrs
        (attrs: {
          # Increase the initial mark stack size to avoid stack
          # overflows, since these inhibit parallel marking (see
          # GC_mark_some()). To check whether the mark stack is too
          # small, run Nix with GC_PRINT_STATS=1 and look for messages
          # such as `Mark stack overflow`, `No room to copy back mark
          # stack`, and `Grew mark stack to ... frames`.
          NIX_CFLAGS_COMPILE = "-DINITIAL_MARK_STACK_SIZE=1048576";
        });

    aws-sdk-cpp =
      (regular.aws-sdk-cpp.override {
        apis = [
          "identity-management"
          "s3"
          "transfer"
        ];
        customMemoryManagement = false;
      }).overrideAttrs
        {
          # only a stripped down version is build which takes a lot less resources to build
          requiredSystemFeatures = [ ];
        };
  };
}
