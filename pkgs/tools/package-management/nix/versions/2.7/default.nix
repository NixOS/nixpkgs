{ common
, fetchpatch
, patch-monitorfdhup
, ...
}:

common {
  version = "2.7.0";
  hash = "sha256-m8tqCS6uHveDon5GSro5yZor9H+sHeh+v/veF1IGw24=";
  patches = [
    # remove when there's a 2.7.1 release
    # https://github.com/NixOS/nix/pull/6297
    # https://github.com/NixOS/nix/issues/6243
    # https://github.com/NixOS/nixpkgs/issues/163374
    (fetchpatch {
      url = "https://github.com/NixOS/nix/commit/c9afca59e87afe7d716101e6a75565b4f4b631f7.patch";
      hash = "sha256-xz7QnWVCI12lX1+K/Zr9UpB93b10t1HS9y/5n5FYf8Q=";
    })
    ../../patches/flaky-tests.patch
    patch-monitorfdhup
  ];
}

