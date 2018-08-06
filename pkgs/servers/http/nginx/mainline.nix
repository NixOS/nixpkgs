{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.15.2";
  sha256 = "145dcypq8dqc5as03iy1ycwifwynq9p4i8m56fn7g0myryp0kfpf";
})
