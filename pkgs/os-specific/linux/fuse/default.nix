{ callPackage, util-linux }:

let
  mkFuse =
    args:
    callPackage (import ./common.nix args) {
      inherit util-linux;
    };
in
{
  fuse_2 = mkFuse {
    version = "2.9.9";
    hash = "sha256-dgjM6M7xk5MHi9xPyCyvF0vq0KM8UCsEYBcMhkrdvfs=";
  };

  fuse_3 = mkFuse {
    version = "3.17.2";
    hash = "sha256-rpWA97ZnoYWEQoUCGtITpx9w1J4qy6LGSxomFNOnKBc=";
  };
}
