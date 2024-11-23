import ./generic.nix {
  version = "14.15";
  hash = "sha256-AuiR4xS06e4ky9eAKNq3xz+cG6PjCDW8vvcf4iBAH8U=";
  muslPatches = {
    disable-test-collate-icu-utf8 = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql14/disable-test-collate.icu.utf8.patch?id=56999e6d0265ceff5c5239f85fdd33e146f06cb7";
      hash = "sha256-jXe23AxnFjEl+TZQm4R7rStk2Leo08ctxMNmu1xr5zM=";
    };
  };
}
