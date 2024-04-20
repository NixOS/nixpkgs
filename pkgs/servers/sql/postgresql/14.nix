import ./generic.nix {
  version = "14.11";
  hash = "sha256-pnC9fc4i3K1Cl7JhE2s7HUoJpvVBcZViqhTKY78paKg=";
  muslPatches = {
    icu-collations-hack = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql14/icu-collations-hack.patch?id=56999e6d0265ceff5c5239f85fdd33e146f06cb7";
      hash = "sha256-wuwjvGHArkRNwFo40g3p43W32OrJohretlt6iSRlJKg=";
    };
    disable-test-collate-icu-utf8 = {
      url = "https://git.alpinelinux.org/aports/plain/main/postgresql14/disable-test-collate.icu.utf8.patch?id=56999e6d0265ceff5c5239f85fdd33e146f06cb7";
      hash = "sha256-jXe23AxnFjEl+TZQm4R7rStk2Leo08ctxMNmu1xr5zM=";
    };
  };
}
