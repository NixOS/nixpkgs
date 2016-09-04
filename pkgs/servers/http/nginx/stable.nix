{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.10.1";
  sha256 = "00d8hxj8453c7989qd7z4f1mjp0k3ib8k29i1qyf11b4ar35ilqz";
})
