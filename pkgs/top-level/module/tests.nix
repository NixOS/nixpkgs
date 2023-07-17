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

  # Helper functions
  noValues = lib.mapAttrs (_: _: null);
  shouldBe = actual: expected: if actual == expected then true else
    builtins.trace "actual:"
    builtins.trace actual
    builtins.trace "expected:"
    builtins.trace expected
    false;

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

  optimizedSimple = invokeModule {
    hostPlatform = "x86_64-linux";
    _memoize = args@{ pkgs, inputsSet, ... }:
      # Don't do this in production. _memoize should be transparent.
      pkgs // { testData = args; };
  };

  optimizedAllOpts = invokeModule {
    config = {
      buildPlatform = "x86_64-linux";
      hostPlatform = "aarch64-linux";
      config = { allowAliases = false; allowUnfree = true; };
      overlays = [ overlayExample ];
      _memoize = args@{ pkgs, inputsSet, ... }:
        # Don't do this in production. _memoize should be transparent.
        pkgs // { testData = args; };
    };
  };

  # All inputs that affect the construction of the package set / arguments to _memoize.
  # Not `_memoize` because it is not an argument to itself.
  # Not `pkgs` because it is not an argument and the result of the `_memoize` call.
  # Not any options that are implemented by only setting one or more of the already listed options (and would be possible to move to a separate module). See the test case with removeAttrs below.
  allInputsSet = {
    buildPlatform = null;
    hostPlatform = null;
    config = null;
    overlays = null;
  };

  tests =
    assert basic.config.pkgs.hello == basicExpect.hello;

    assert cross.config.pkgs.hello == crossExpect.hello;

    assert overlay.config.pkgs.hello.name == "helloFromOverlay";

    assert havingConfig.config.pkgs.perlPackages.just-a-proof-of-use;

    assert noValues optimizedSimple.config.pkgs.testData.inputsSet == { hostPlatform = null; };

    assert noValues optimizedAllOpts.config.pkgs.testData.inputsSet == allInputsSet;

    # Make sure that all necessary options are part of inputsSet. This will fail
    # if an option is added without considering this. If the new option is a new
    # addition to the unique key, it should be added to allInputsSet.
    assert shouldBe
      (builtins.removeAttrs (noValues optimizedAllOpts.options) [
        # All options that do not directly affect the construction of pkgs.
        # If a new option's effect is implemented by setting one of the options
        # already in `inputsSet`, it does not need to be listed here.
        #
        # See comment on `allInputsSet`.
        # Defined by us
        "pkgs" "_memoize"

        # From the module system itself
        "_module"
      ])
      allInputsSet;

    emptyFile;
}
