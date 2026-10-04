{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-node";
  component = "node";

  hashes = {
    linux_x64 = "sha256-04p0cnGBk8QYkXrBvMuWp9zTj0TRKkoDgauM869uAQk=";
    linux_arm64 = "sha256-uYSobyLhAF7yurEV5rZpvSZ1TeD7SyGuRB0xAcKAeGc=";
    darwin_x64 = "sha256-DIQfv7/BOwi8mTzpawaN0EFHt6jB7SVVGs3KonndWPQ=";
    darwin_arm64 = "sha256-n4oouS/+2KTCO5E+cy2NNnhF7UjlQ7YAqow9NFX3N2E=";
  };

  includeInPath = [ ccextractor ];
}
