{ lib, ... }:
lib.recurseIntoAttrs {

  # https://github.com/NixOS/nixpkgs/issues/175196
  # This test has since been simplified to test the recursion without
  # the fluff to make it look like a real-world example.
  # The requirement we test here is:
  # - `permittedInsecurePackages` must be allowed to
  #   use `pkgs` to retrieve at least *some* information.
  #
  # Instead of `builtins.seq`, the list may be constructed based on actual package info.
  allowPkgsInPermittedInsecurePackages =
    let pkgs = import ../.. {
          config = {
            permittedInsecurePackages = builtins.seq pkgs.glibc.version [];
          };
        };

    in pkgs.hello;

}
