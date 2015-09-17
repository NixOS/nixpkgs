{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {

  version = "3.0.2.0";

  sha256 = "0qfzx3sqx4mwxv99sfybhsij4b5pc03ricl73h4vhkzazgjjjhfm";

})
