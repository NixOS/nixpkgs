{ common
, fetchpatch
, patch-sqlite-exception
, patch-monitorfdhup
, ...
}:

common {
  version = "2.9.2";
  hash = "sha256-uZCaBo9rdWRO/AlQMvVVjpAwzYijB2H5KKQqde6eHkg=";
  patches = [
    (fetchpatch {
      # https://github.com/NixOS/nix/pull/7283
      name = "fix-requires-non-existing-output.patch";
      url = "https://github.com/NixOS/nix/commit/3ade5f5d6026b825a80bdcc221058c4f14e10a27.patch";
      hash = "sha256-s1ybRFCjQaSGj7LKu0Z5g7UiHqdJGeD+iPoQL0vaiS0=";
    })
    patch-sqlite-exception
    patch-monitorfdhup
    ../../patches/flaky-tests.patch
  ];
}
