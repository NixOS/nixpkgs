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

  composePackageSets = with pkgs;
    let
      # To silence platform specific evaluation errors
      discardEvaluationErrors = e:
        let res = builtins.tryEval e; in
        res.success == res.value;

      # Basic test for idempotency of the package set, i.e:
      # Applying the same package set twice should work and
      # not change anything.
      isIdempotent = set: discardEvaluationErrors (
        pkgs.${set}.stdenv == pkgs.${set}.${set}.stdenv
      );

      # Some package sets should be noops in certain circumstances.
      # This is very similar to the idempotency test, but not going
      # via the super' overlay.
      isNoop = parent: child: discardEvaluationErrors (
        (lib.getAttrFromPath parent pkgs).stdenv ==
        (lib.getAttrFromPath parent pkgs).${child}.stdenv
      );

      allMuslExamples = builtins.attrNames (lib.filterAttrs
        (_: { config, ... }: lib.hasSuffix "-musl" config)
        lib.systems.examples);

      allLLVMExamples = builtins.attrNames (lib.filterAttrs
        (_: { useLLVM ? false, ... }: useLLVM)
        lib.systems.examples);

      # A package set should only change specific configuration, but needs
      # to keep all other configuration from previous layers in place.
      # Each package set has one or more key characteristics for which we
      # test here. Those should be kept, even when applying the "set" package
      # set.
      isComposable = set:
        discardEvaluationErrors (pkgsCross.mingwW64.${set}.stdenv.hostPlatform.config == "x86_64-w64-mingw32") &&
        discardEvaluationErrors (pkgsCross.mingwW64.${set}.stdenv.hostPlatform.libc == "msvcrt") &&
        discardEvaluationErrors (pkgsCross.ppc64-musl.${set}.stdenv.hostPlatform.gcc.abi == "elfv2") &&
        discardEvaluationErrors (builtins.elem "zerocallusedregs" pkgs.pkgsExtraHardening.${set}.stdenv.cc.defaultHardeningFlags) &&
        discardEvaluationErrors (pkgs.pkgsLLVM.${set}.stdenv.hostPlatform.useLLVM) &&
        discardEvaluationErrors (pkgs.pkgsLinux.${set}.stdenv.buildPlatform.isLinux) &&
        discardEvaluationErrors (pkgs.pkgsMusl.${set}.stdenv.hostPlatform.isMusl) &&
        discardEvaluationErrors (pkgs.pkgsStatic.${set}.stdenv.hostPlatform.isStatic) &&
        discardEvaluationErrors (pkgs.pkgsi686Linux.${set}.stdenv.hostPlatform.isx86_32) &&
        discardEvaluationErrors (pkgs.pkgsx86_64Darwin.${set}.stdenv.hostPlatform.isx86_64);
    in
      # Appends same flags over and over again
      # assert isIdempotent "pkgsExtraHardening";
      assert isIdempotent "pkgsLLVM";
      assert isIdempotent "pkgsLinux";
      assert isIdempotent "pkgsMusl";
      assert isIdempotent "pkgsStatic";
      assert isIdempotent "pkgsi686Linux";
      assert isIdempotent "pkgsx86_64Darwin";

      # TODO: fails
      # assert isNoop [ "pkgsStatic" ] "pkgsMusl";
      # TODO: fails because of ppc64-musl
      # assert lib.all (sys: isNoop [ "pkgsCross" sys ] "pkgsMusl") allMuslExamples;
      assert lib.all (sys: isNoop [ "pkgsCross" sys ] "pkgsLLVM") allLLVMExamples;

      assert isComposable "pkgsExtraHardening";
      assert isComposable "pkgsLLVM";
      # TODO: attribute 'useLLVM' missing
      # assert isComposable "pkgsMusl";
      assert isComposable "pkgsStatic";
      # assert isComposable "pkgsi686Linux";

      # Special cases regarding buildPlatform vs hostPlatform
      # TODO: fails
      # assert discardEvaluationErrors (pkgsCross.gnu64.pkgsMusl.stdenv.hostPlatform.isMusl);
      # assert discardEvaluationErrors (pkgsCross.gnu64.pkgsi686Linux.stdenv.hostPlatform.isx86_32);
      # assert discardEvaluationErrors (pkgsCross.mingwW64.pkgsLinux.stdenv.hostPlatform.isLinux);
      # assert discardEvaluationErrors (pkgsCross.aarch64-darwin.pkgsx86_64Darwin.stdenv.hostPlatform.isx86_64);

      emptyFile;
}
