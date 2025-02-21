{
  lib,
  libc,
  config,
  system,
  bootstrapFiles,
  isFromBootstrapFiles ? false,
}:

let
  maybeDenoteProvenance = lib.optionalAttrs isFromBootstrapFiles {
    passthru = {
      inherit isFromBootstrapFiles;
    };
  };

  maybeContentAddressed = lib.optionalAttrs config.contentAddressedByDefault {
    __contentAddressed = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  args = {
    inherit system bootstrapFiles;
    extraAttrs = maybeContentAddressed;
  };
  result =
    if libc == "glibc" then
      import ./glibc.nix args
    else if libc == "musl" then
      import ./musl.nix args
    else
      throw "unsupported libc";
in
result // maybeDenoteProvenance
