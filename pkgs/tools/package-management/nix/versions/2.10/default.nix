{ common
, fetchpatch
, patch-sqlite-exception
, patch-monitorfdhup
, ...
}:

common {
  version = "2.10.3";
  hash = "sha256-B9EyDUz/9tlcWwf24lwxCFmkxuPTVW7HFYvp0C4xGbc=";
  patches = [
    ../../patches/flaky-tests.patch
    (fetchpatch {
      # https://github.com/NixOS/nix/pull/7283
      name = "fix-requires-non-existing-output.patch";
      url = "https://github.com/NixOS/nix/commit/3ade5f5d6026b825a80bdcc221058c4f14e10a27.patch";
      hash = "sha256-s1ybRFCjQaSGj7LKu0Z5g7UiHqdJGeD+iPoQL0vaiS0=";
    })
    patch-sqlite-exception
    patch-monitorfdhup
  ];
}
