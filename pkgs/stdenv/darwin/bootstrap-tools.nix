{
  lib,
  stdenv,
  bootstrapTools,
  unpack,
}:

builtins.derivation {
  inherit (stdenv.hostPlatform) system;

  name = "bootstrap-tools";
  builder = "${unpack}/bin/bash";

  args = [
    "${unpack}/bootstrap-tools-unpack.sh"
    bootstrapTools
  ];

  PATH = lib.makeBinPath [
    (builtins.placeholder "out")
    unpack
  ];

  allowedReferences = [ "out" ];
}
