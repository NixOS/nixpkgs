import ./generic.nix {
  version = "1.7.3";
  hash = "sha256-eptbxhbd3pUvYCncgKprh0qes9CjdvGUl3CsG/sHX7M=";
  cargoHash = "sha256-M0TXGvpMkV/4U0MRYVqiWQsA+9AHdeS89noLxE2Llt0=";
  patches = [
    # remove 1.7.4 - https://github.com/kanidm/kanidm/issues/3813
    ./a3bc718a8a0325a53e0857668b8a0134d371794d.patch
  ];
}
