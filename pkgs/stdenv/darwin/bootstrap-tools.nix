{
  lib,
  stdenv,
  bootstrapTools,
  unpack,
}:

derivation {
  inherit (stdenv.hostPlatform) system;

  name = "bootstrap-tools";
  builder = "${unpack}/bin/bash";

  args = [
    "${unpack}/bootstrap-tools-unpack.sh"
    bootstrapTools
  ];

  PATH = lib.makeBinPath [
    (placeholder "out")
    unpack
  ];

  allowedReferences = [ "out" ];
}
