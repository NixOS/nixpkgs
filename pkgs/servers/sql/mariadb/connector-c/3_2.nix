{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.2.7";
  hash = "sha256-nXGWJI5ml8Ccc+Fz/psoIEX1XsnXrnQ8HrrQi56lbdo=";
})
