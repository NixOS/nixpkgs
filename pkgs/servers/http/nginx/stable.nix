{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.10.2";
  sha256 = "1hk5szkwns6s0xsvd0aiy392sqbvk3wdl480bpxf55m3hx4sqi8h";
})
