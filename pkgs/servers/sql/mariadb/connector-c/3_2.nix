{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.2.3";
  sha256 = "1x1i4ck4c3sgkw083v02zk3rbkm5h0x1vl4m58j95q1qcijkiamn";
})
