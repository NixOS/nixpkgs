# run like this:
#  nix-build pkgs/test/top-level/stage.nix
{
  localSystem ? {
    system = builtins.currentSystem;
  },
}:

with import ../../top-level { inherit localSystem; };

let
  # To silence platform specific evaluation errors
  discardEvaluationErrors = e: (builtins.tryEval e).success -> e;

  # Basic test for idempotency of the package set, i.e:
  # Applying the same package set twice should work and
  # not change anything.
  isIdempotent = set: discardEvaluationErrors (pkgs.${set}.stdenv == pkgs.${set}.${set}.stdenv);

  # Some package sets should be noops in certain circumstances.
  # This is very similar to the idempotency test, but not going
  # via the super' overlay.
  isNoop =
    parent: child:
    discardEvaluationErrors (
      (lib.getAttrFromPath parent pkgs).stdenv == (lib.getAttrFromPath parent pkgs).${child}.stdenv
    );

  allMuslExamples = builtins.attrNames (
    lib.filterAttrs (_: system: lib.hasSuffix "-musl" system.config) lib.systems.examples
  );

  allLLVMExamples = builtins.attrNames (
    lib.filterAttrs (_: system: system.useLLVM or false) lib.systems.examples
  );

  # A package set should only change specific configuration, but needs
  # to keep all other configuration from previous layers in place.
  # Each package set has one or more key characteristics for which we
  # test here. Those should be kept, even when applying the "set" package
  # set.
  isComposable =
    set:
    lib.all discardEvaluationErrors (
      [
        (pkgsCross.ppc64-musl.${set}.stdenv.hostPlatform.gcc.abi == "elfv2")
        (pkgs.pkgsLLVM.${set}.stdenv.hostPlatform.useLLVM)
        (pkgs.pkgsArocc.${set}.stdenv.hostPlatform.useArocc)
        (pkgs.pkgsZig.${set}.stdenv.hostPlatform.useZig)
        (pkgs.pkgsLinux.${set}.stdenv.buildPlatform.isLinux)
        (pkgs.pkgsStatic.${set}.stdenv.hostPlatform.isStatic)
        (pkgs.pkgsi686Linux.${set}.stdenv.hostPlatform.isx86_32)
        (pkgs.pkgsx86_64Darwin.${set}.stdenv.hostPlatform.isx86_64)
        (builtins.elem "trivialautovarinit" pkgs.pkgsExtraHardening.${set}.stdenv.cc.defaultHardeningFlags)
      ] # Can't compose two different libcs...
      ++ lib.optionals (!builtins.elem set [ "pkgsLLVMLibc" ]) [
        (pkgsCross.mingwW64.${set}.stdenv.hostPlatform.config == "x86_64-w64-mingw32")
        (pkgsCross.mingwW64.${set}.stdenv.hostPlatform.libc == "msvcrt")
        (pkgs.pkgsMusl.${set}.stdenv.hostPlatform.isMusl)
      ]
      ++
        lib.optionals
          (
            !builtins.elem set [
              "pkgsMusl"
              "pkgsStatic"
            ]
          )
          [
            (pkgs.pkgsLLVMLibc.${set}.stdenv.hostPlatform.isLLVMLibc)
          ]
    );
in

# Appends same defaultHardeningFlags again on each .pkgsExtraHardening - thus not idempotent.
# assert isIdempotent "pkgsExtraHardening";
# TODO: Remove the isDarwin condition, which currently results in infinite recursion.
# Also see https://github.com/NixOS/nixpkgs/pull/330567#discussion_r1894653309
assert (stdenv.hostPlatform.isDarwin || isIdempotent "pkgsLLVM");
# TODO: This currently results in infinite recursion, even on Linux
# assert isIdempotent "pkgsLLVMLibc";
assert isIdempotent "pkgsArocc";
assert isIdempotent "pkgsZig";
assert isIdempotent "pkgsLinux";
assert isIdempotent "pkgsMusl";
assert isIdempotent "pkgsStatic";
assert isIdempotent "pkgsi686Linux";
assert isIdempotent "pkgsx86_64Darwin";

assert isNoop [ "pkgsStatic" ] "pkgsMusl";
assert lib.all (sys: isNoop [ "pkgsCross" sys ] "pkgsMusl") allMuslExamples;
# This will fail on all systems which are not handled in pkgs/os-specific/bsd/openbsd/pkgs/mkDerivation.nix,
# for example armv6l-linux, powerpc64le-linux, riscv64-linux
assert lib.all (sys: isNoop [ "pkgsCross" sys ] "pkgsLLVM") allLLVMExamples;

assert isComposable "pkgsExtraHardening";
assert isComposable "pkgsLLVM";
# TODO: Results in infinite recursion
# assert isComposable "pkgsLLVMLibc";
assert isComposable "pkgsArocc";
assert isComposable "pkgsZig";
assert isComposable "pkgsMusl";
assert isComposable "pkgsStatic";
assert isComposable "pkgsi686Linux";

# Special cases regarding buildPlatform vs hostPlatform
assert discardEvaluationErrors (pkgsCross.gnu64.pkgsMusl.stdenv.hostPlatform.isMusl);
assert discardEvaluationErrors (pkgsCross.gnu64.pkgsi686Linux.stdenv.hostPlatform.isx86_32);
assert discardEvaluationErrors (pkgsCross.mingwW64.pkgsLinux.stdenv.hostPlatform.isLinux);
assert discardEvaluationErrors (
  pkgsCross.aarch64-darwin.pkgsx86_64Darwin.stdenv.hostPlatform.isx86_64
);

# pkgsCross should keep upper cross settings
assert discardEvaluationErrors (
  with pkgsStatic.pkgsCross.gnu64.stdenv.hostPlatform; isGnu && isStatic
);
assert discardEvaluationErrors (
  with pkgsLLVM.pkgsCross.musl64.stdenv.hostPlatform; isMusl && useLLVM
);

emptyFile
