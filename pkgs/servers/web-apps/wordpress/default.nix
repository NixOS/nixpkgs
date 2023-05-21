{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress6_2;
  wordpress6_2 = {
    version = "6.2.1";
    hash = "sha256-jGmOEmdj3n4bCoTJH/4DEsjTBiaEmaxBt1kA19HctU8=";
  };
  wordpress6_1 = {
    version = "6.1.2";
    hash = "sha256-ozpuCVeni71CUylmUBk8wVo5ygZAKY7IdZ12DKbpSrw=";
  };
}
