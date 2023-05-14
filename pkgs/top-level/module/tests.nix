/*
  Run
  [nixpkgs]$ nix-build -A tests.top-level.module --show-trace

  Repl
  [nixpkgs]$ nix repl pkgs/top-level/module/tests.nix --show-trace
  nix-repl> tests
  "ok"
*/

# This function is `callPackage`d, but we'd like to load it in nix repl as well,
# so we add some defaults.
{ lib ? import ../../../lib, emptyFile ? "ok" }:

# We define use a rec {} mostly as a let binding, as the tests attribute is all
# that really matters for running the tests. However, having access to all the
# other attributes is useful for debugging.
rec {
  inherit (lib) evalModules;

  invokeModule = callerModule: evalModules { modules = [ ./module.nix callerModule ]; };

  basic = invokeModule { hostPlatform = "x86_64-linux"; };
  basicExpect = import ../default.nix { localSystem = "x86_64-linux"; };

  cross = invokeModule { buildPlatform = "x86_64-linux"; hostPlatform = "aarch64-linux"; };
  crossExpect = import ../default.nix { localSystem = "x86_64-linux"; crossSystem = "aarch64-linux"; };

  overlayExample = self: super: { hello = super.hello.overrideAttrs (old: { name = "helloFromOverlay"; }); };

  overlay = invokeModule {
    hostPlatform = "x86_64-linux";
    overlays = [ overlayExample ];
  };
  # overlayExpect = import ../default.nix { localSystem = "x86_64-linux"; overlays = [ overlayExample ]; };

  havingConfig = invokeModule {
    # Defining a value for an option named `config` is a bit awkward withou
    # the shorthand syntax. This is noted in the module file's top comment.
    config = {
      hostPlatform = "x86_64-linux";
      config = {
        # Not the most popular config option, but one that is easy to test.
        perlPackageOverrides = pkgs: { just-a-proof-of-use = true; };
      };
    };
  };

  tests =
    assert basic.config.pkgs.hello == basicExpect.hello;

    assert cross.config.pkgs.hello == crossExpect.hello;

    assert overlay.config.pkgs.hello.name == "helloFromOverlay";

    assert havingConfig.config.pkgs.perlPackages.just-a-proof-of-use;

    emptyFile;
}
