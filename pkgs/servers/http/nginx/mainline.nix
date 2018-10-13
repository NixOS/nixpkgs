{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.15.5";
  sha256 = "0vxfbnc1794al60d9mhjw1w72x5jslfwq51vvs38568liyd8hfhs";
})
