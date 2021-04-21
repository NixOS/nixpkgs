{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.1.12";
  sha256 = "0qzyahr8x9l1xz0l79wz3iahxz7648n1azc5yr7kx0dl113y2nig";
})
