{
  lib,
  config,
  pkgs,
  ...
}:
let
  nixpkgsFun = import ../top-level;

  evalNixos =
    modules:
    import ../../nixos/lib/eval-config.nix {
      modules = [ { nixpkgs.hostPlatform = "x86_64-linux"; } ] ++ modules;
    };

  localSystem = {
    system = "x86_64-linux";
  };
in
lib.recurseIntoAttrs {

  # `nixpkgs.config` is merged by the module system, so definitions from
  # separate modules combine and properties such as `mkForce` are resolved.
  # The result reaches every package set variant, including the ones that
  # override `config` themselves.
  # Regression test for https://github.com/NixOS/nixpkgs/issues/550852
  fromNixosModules =
    let
      nixosPkgs =
        (evalNixos [
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.allowBroken = true;
          }
          { nixpkgs.config.allowBroken = lib.mkForce false; }
        ]).pkgs;
      cross = nixosPkgs.pkgsCross.aarch64-multiplatform;
    in
    assert nixosPkgs.config.allowUnfree;
    assert !nixosPkgs.config.allowBroken;
    # Variants overriding `config` keep the definitions and apply their own.
    assert nixosPkgs.pkgsRocm.config.rocmSupport;
    assert !nixosPkgs.pkgsRocm.config.cudaSupport;
    assert nixosPkgs.pkgsRocm.config.allowUnfree;
    assert !nixosPkgs.pkgsRocm.config.allowBroken;
    # Variants not overriding `config` resolve the definitions themselves.
    assert cross.config.allowUnfree;
    assert !cross.config.allowBroken;
    pkgs.emptyFile;

  # `nixpkgs.config` may also be written as a module function, and options
  # nobody defined keep the defaults declared in `pkgs/top-level/config.nix`.
  fromNixosModuleFunction =
    let
      nixosPkgs =
        (evalNixos [
          {
            nixpkgs.config =
              { lib, ... }:
              {
                allowBroken = lib.isFunction lib.id;
              };
          }
        ]).pkgs;
    in
    assert nixosPkgs.config.allowBroken;
    assert !nixosPkgs.config.allowUnfree;
    pkgs.emptyFile;

  # Standalone, `config` accepts an attribute set, a function returning one,
  # or a list of modules. The NixOS module uses the last form to forward its
  # definitions unevaluated.
  configForms =
    let
      fromAttrs = nixpkgsFun {
        inherit localSystem;
        config.allowUnfree = true;
      };
      fromFunction = nixpkgsFun {
        inherit localSystem;
        config =
          { lib, pkgs }:
          {
            allowUnfree = lib.isAttrs pkgs;
          };
      };
      fromModules = nixpkgsFun {
        inherit localSystem;
        config = [
          { allowUnfree = true; }
          { allowBroken = true; }
          { allowBroken = lib.mkForce false; }
        ];
      };
      conflicting = nixpkgsFun {
        inherit localSystem;
        config = [
          { fetchedSourceNameDefault = "versioned"; }
          { fetchedSourceNameDefault = "full"; }
        ];
      };
      defaults = nixpkgsFun { inherit localSystem; };
    in
    assert fromAttrs.config.allowUnfree;
    assert fromFunction.config.allowUnfree;
    assert fromModules.config.allowUnfree;
    assert !fromModules.config.allowBroken;
    assert !defaults.config.allowUnfree;
    # Conflicting definitions of a `uniq` option must fail loudly rather than
    # silently picking one of them. The error text is checked in
    # `ci/config-nix-unit`, which `builtins.tryEval` cannot do.
    assert !(builtins.tryEval conflicting.config.fetchedSourceNameDefault).success;
    pkgs.emptyFile;

  # https://github.com/NixOS/nixpkgs/issues/175196
  # This test has since been simplified to test the recursion without
  # the fluff to make it look like a real-world example.
  # The requirement we test here is:
  # - `permittedInsecurePackages` must be allowed to
  #   use `pkgs` to retrieve at least *some* information.
  #
  # Instead of `builtins.seq`, the list may be constructed based on actual package info.
  allowPkgsInPermittedInsecurePackages =
    let
      pkgs' = import ../.. {
        system = pkgs.stdenv.hostPlatform.system;
        config = config // {
          permittedInsecurePackages = builtins.seq pkgs'.glibc.version [ ];
        };
      };

    in
    pkgs'.hello;

}
