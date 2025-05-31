/*
  This file contains all of the different variants of nixpkgs instances.

  Unlike the other package sets like pkgsCross, pkgsi686Linux, etc., this
  contains non-critical package sets. The intent is to be a shorthand
  for things like using different toolchains in every package in nixpkgs.
*/
{
  lib,
  stdenv,
  nixpkgsFun,
  overlays,
  makeMuslParsedPlatform,
}:
let
  makeLLVMParsedPlatform =
    parsed:
    (
      parsed
      // {
        abi = lib.systems.parse.abis.llvm;
      }
    );
in
self: super: {
  pkgsLLVM = nixpkgsFun {
    overlays = [
      (self': super': {
        pkgsLLVM = super';
      })
    ] ++ overlays;
    # Bootstrap a cross stdenv using the LLVM toolchain.
    # This is currently not possible when compiling natively,
    # so we don't need to check hostPlatform != buildPlatform.
    crossSystem = stdenv.hostPlatform // {
      useLLVM = true;
      linker = "lld";
    };
  };

  pkgsArocc = nixpkgsFun {
    overlays = [
      (self': super': {
        pkgsArocc = super';
      })
    ] ++ overlays;
    # Bootstrap a cross stdenv using the Aro C compiler.
    # This is currently not possible when compiling natively,
    # so we don't need to check hostPlatform != buildPlatform.
    crossSystem = stdenv.hostPlatform // {
      useArocc = true;
      linker = "lld";
    };
  };

  pkgsZig = nixpkgsFun {
    overlays = [
      (self': super': {
        pkgsZig = super';
      })
    ] ++ overlays;
    # Bootstrap a cross stdenv using the Zig toolchain.
    # This is currently not possible when compiling natively,
    # so we don't need to check hostPlatform != buildPlatform.
    crossSystem = stdenv.hostPlatform // {
      useZig = true;
      linker = "lld";
    };
  };

  # All packages built with the Musl libc. This will override the
  # default GNU libc on Linux systems. Non-Linux systems are not
  # supported. 32-bit is also not supported.
  pkgsMusl =
    if stdenv.hostPlatform.isLinux && stdenv.buildPlatform.is64bit then
      nixpkgsFun {
        overlays = [
          (self': super': {
            pkgsMusl = super';
          })
        ] ++ overlays;
        ${if stdenv.hostPlatform == stdenv.buildPlatform then "localSystem" else "crossSystem"} = {
          config = lib.systems.parse.tripleFromSystem (makeMuslParsedPlatform stdenv.hostPlatform.parsed);
        };
      }
    else
      throw "Musl libc only supports 64-bit Linux systems.";

  # Full package set with rocm on cuda off
  # Mostly useful for asserting pkgs.pkgsRocm.torchWithRocm == pkgs.torchWithRocm and similar
  pkgsRocm = nixpkgsFun ({
    config = super.config // {
      cudaSupport = false;
      rocmSupport = true;
    };
  });

  pkgsExtraHardening = nixpkgsFun {
    overlays = [
      (
        self': super':
        {
          pkgsExtraHardening = super';
          stdenv = super'.withDefaultHardeningFlags (
            super'.stdenv.cc.defaultHardeningFlags
            ++ [
              "strictflexarrays1"
              "shadowstack"
              "nostrictaliasing"
              "pacret"
              "trivialautovarinit"
            ]
          ) super'.stdenv;
          glibc = super'.glibc.override rec {
            enableCET = if self'.stdenv.hostPlatform.isx86_64 then "permissive" else false;
            enableCETRuntimeDefault = enableCET != false;
          };
        }
        // lib.optionalAttrs (with super'.stdenv.hostPlatform; isx86_64 && isLinux) {
          # causes shadowstack disablement
          pcre = super'.pcre.override { enableJit = false; };
          pcre-cpp = super'.pcre-cpp.override { enableJit = false; };
        }
      )
    ] ++ overlays;
  };
}
