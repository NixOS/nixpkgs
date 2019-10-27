{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.1.2";
  sha256 = "0pgz8m8d39mvj9wnjll6c83xvdl2h24273b3dkx0g5pxj7ga4shm";
})
