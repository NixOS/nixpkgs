# nix-build -A tests.top-level
{ lib, pkgs, ... }:
let
  nixpkgsFun = import ../../top-level;
in
lib.recurseIntoAttrs {
  platformEquality =
    let
      configsLocal = [
        # crossSystem is implicitly set to localSystem.
        {
          localSystem = { system = "x86_64-linux"; };
        }
        {
          localSystem = { system = "aarch64-linux"; };
          crossSystem = null;
        }
        # Both systems explicitly set to the same string.
        {
          localSystem = { system = "x86_64-linux"; };
          crossSystem = { system = "x86_64-linux"; };
        }
        # Vendor and ABI inferred from system double.
        {
          localSystem = { system = "aarch64-linux"; };
          crossSystem = { config = "aarch64-unknown-linux-gnu"; };
        }
      ];
      configsCross = [
        # GNU is inferred from double, but config explicitly requests musl.
        {
          localSystem = { system = "aarch64-linux"; };
          crossSystem = { config = "aarch64-unknown-linux-musl"; };
        }
        # Cross-compile from AArch64 to x86-64.
        {
          localSystem = { system = "aarch64-linux"; };
          crossSystem = { system = "x86_64-unknown-linux-gnu"; };
        }
      ];

      pkgsLocal = map nixpkgsFun configsLocal;
      pkgsCross = map nixpkgsFun configsCross;
    in
    assert lib.all (p: p.buildPlatform == p.hostPlatform) pkgsLocal;
    assert lib.all (p: p.buildPlatform != p.hostPlatform) pkgsCross;
    pkgs.emptyFile;

  invocations-pure =
    let
      inherit (lib.systems) elaborate;
      assertEqualPkgPlatforms = a: b:
        # NOTE: equals should become obsolete, but currently isn't when comparing
        #       between two distinct Nixpkgs invocations
        #       `equals` should not be used in most places because it is a bit slow.
        assert lib.systems.equals a.stdenv.hostPlatform b.stdenv.hostPlatform;
        assert lib.systems.equals a.stdenv.buildPlatform b.stdenv.buildPlatform;
        assert lib.systems.equals a.stdenv.targetPlatform b.stdenv.targetPlatform;
        true;

      native-s = import ../../.. { system = "i686-linux"; };
      native-ls = import ../../.. { localSystem.system = "i686-linux"; };
      native-le = import ../../.. { localSystem = lib.systems.elaborate "i686-linux"; };
      native-h = import ../../.. { hostPlatform = "i686-linux"; };
      native-he = import ../../.. { hostPlatform = lib.systems.elaborate "i686-linux"; };

      cross-1-s-cs = import ../../.. { system = "i686-linux"; crossSystem = "armv7l-linux"; };
      cross-1-s-css = import ../../.. { system = "i686-linux"; crossSystem.system = "armv7l-linux"; };
      cross-1-s-cse = import ../../.. { system = "i686-linux"; crossSystem = elaborate "armv7l-linux"; };
      cross-1-ls-cs = import ../../.. { localSystem.system = "i686-linux"; crossSystem = "armv7l-linux"; };
      cross-1-ls-css = import ../../.. { localSystem.system = "i686-linux"; crossSystem.system = "armv7l-linux"; };
      cross-1-ls-cse = import ../../.. { localSystem.system = "i686-linux"; crossSystem = elaborate "armv7l-linux"; };
      cross-1-le-cs = import ../../.. { localSystem = elaborate "i686-linux"; crossSystem = "armv7l-linux"; };
      cross-1-le-css = import ../../.. { localSystem = elaborate "i686-linux"; crossSystem.system = "armv7l-linux"; };
      cross-1-le-cse = import ../../.. { localSystem = elaborate "i686-linux"; crossSystem = elaborate "armv7l-linux"; };
      cross-1-b-h = import ../../.. { buildPlatform = "i686-linux"; hostPlatform = "armv7l-linux"; };
      cross-1-b-hs = import ../../.. { buildPlatform = "i686-linux"; hostPlatform.system = "armv7l-linux"; };
      cross-1-b-he = import ../../.. { buildPlatform = "i686-linux"; hostPlatform = elaborate "armv7l-linux"; };
      cross-1-bs-h = import ../../.. { buildPlatform.system = "i686-linux"; hostPlatform = "armv7l-linux"; };
      cross-1-bs-hs = import ../../.. { buildPlatform.system = "i686-linux"; hostPlatform.system = "armv7l-linux"; };
      cross-1-bs-he = import ../../.. { buildPlatform.system = "i686-linux"; hostPlatform = elaborate "armv7l-linux"; };
      cross-1-be-h = import ../../.. { buildPlatform = elaborate "i686-linux"; hostPlatform = "armv7l-linux"; };
      cross-1-be-hs = import ../../.. { buildPlatform = elaborate "i686-linux"; hostPlatform.system = "armv7l-linux"; };
      cross-1-be-he = import ../../.. { buildPlatform = elaborate "i686-linux"; hostPlatform = elaborate "armv7l-linux"; };

    in

    # NATIVE
    # ------

    assert lib.systems.equals native-s.stdenv.hostPlatform (elaborate "i686-linux");
    assert lib.systems.equals native-s.stdenv.buildPlatform (elaborate "i686-linux");

    # sample reflexivity (sanity check)
    assert assertEqualPkgPlatforms native-s native-s;
    # check the rest (assume transitivity to avoid n^2 checks)
    assert assertEqualPkgPlatforms native-s native-ls;
    assert assertEqualPkgPlatforms native-s native-le;
    assert assertEqualPkgPlatforms native-s native-h;
    assert assertEqualPkgPlatforms native-s native-he;

    # These pairs must be identical
    assert native-s.stdenv.hostPlatform == native-s.stdenv.buildPlatform;
    assert native-ls.stdenv.hostPlatform == native-ls.stdenv.buildPlatform;
    assert native-le.stdenv.hostPlatform == native-le.stdenv.buildPlatform;
    assert native-h.stdenv.hostPlatform == native-h.stdenv.buildPlatform;
    assert native-he.stdenv.hostPlatform == native-he.stdenv.buildPlatform;


    # CROSS
    # -----

    assert lib.systems.equals cross-1-s-cs.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-s-cs.stdenv.buildPlatform (elaborate "i686-linux");

    # sample reflexivity (sanity check)
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-s-cs;
    # check the rest (assume transitivity to avoid n^2 checks)
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-s-css;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-s-cse;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-ls-cs;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-ls-css;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-ls-cse;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-le-cs;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-le-css;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-le-cse;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-b-h;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-b-hs;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-b-he;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-bs-h;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-bs-hs;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-bs-he;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-be-h;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-be-hs;
    assert assertEqualPkgPlatforms cross-1-s-cs cross-1-be-he;

    assert lib.systems.equals cross-1-s-cs.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-s-css.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-s-cse.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-ls-cs.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-ls-css.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-ls-cse.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-le-cs.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-le-css.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-le-cse.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-b-h.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-b-hs.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-b-he.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-bs-h.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-bs-hs.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-bs-he.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-be-h.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-be-hs.stdenv.hostPlatform (elaborate "armv7l-linux");
    assert lib.systems.equals cross-1-be-he.stdenv.hostPlatform (elaborate "armv7l-linux");

    assert lib.systems.equals cross-1-s-cs.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-s-css.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-s-cse.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-ls-cs.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-ls-css.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-ls-cse.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-le-cs.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-le-css.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-le-cse.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-b-h.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-b-hs.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-b-he.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-bs-h.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-bs-hs.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-bs-he.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-be-h.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-be-hs.stdenv.buildPlatform (elaborate "i686-linux");
    assert lib.systems.equals cross-1-be-he.stdenv.buildPlatform (elaborate "i686-linux");

    # builtins.trace ''
    #   Tests passed, but note that the impure use cases are not included here.

    #   Impurely specified native compilation,
    #   currentSystem as build -> currentSystem as host:

    #       nix-build -A hello

    #   Impurely specified cross compilation for specified host,
    #   currentSystem as build -> crossSystem as host:

    #       nix-build --argstr crossSystem armv7l-linux -A hello

    # ''



    pkgs.emptyFile;

  invocations-impure =
    if !builtins?currentSystem
    then
      lib.trace
        "Skipping invocations-impure test, because we don't have currentSystem here. Don't forget to also run the top-level tests in impure mode!"
        pkgs.emptyFile
    else
      let
        # As a mere expression, we don't get to pick currentSystem, so we have to
        # pick a different one dynamically.
        otherSystem = if builtins.currentSystem == "x86_64-linux" then "aarch64-linux" else "x86_64-linux";
        otherSystemElaborated = lib.systems.elaborate otherSystem;
        currentSystemElaborated = lib.systems.elaborate builtins.currentSystem;

        impureNative = import ../../.. { };
        impureCross = import ../../.. { crossSystem = otherSystem; };
      in
        # Obviously
        assert ! lib.systems.equals currentSystemElaborated otherSystemElaborated;

        assert lib.systems.equals impureNative.stdenv.hostPlatform currentSystemElaborated;
        assert lib.systems.equals impureNative.stdenv.buildPlatform currentSystemElaborated;

        assert lib.systems.equals impureCross.stdenv.hostPlatform otherSystemElaborated;
        assert lib.systems.equals impureCross.stdenv.buildPlatform currentSystemElaborated;

        pkgs.emptyFile;
}
