{ lib
, stdenv
, callPackage
, fetchFromGitHub

, overrideCC
, buildPackages

# We need a riscv32-none-targeted clang to build the software part
# of the bitstream, but it is somewhat inaccurate to say that the
# hostPlatform of this package is riscv32.
, pkgsCross
}:

let
  pkgsOnBuildForTarget = pkgsCross.tillitis.pkgsBuildTarget;
  llvm_onBuildForTarget = pkgsOnBuildForTarget.llvmPackages_15;
  tillitis-cpu-stdenv =
    overrideCC
      llvm_onBuildForTarget.stdenv
      (pkgsOnBuildForTarget.targetPackages.wrapCCWith {
        cc = llvm_onBuildForTarget.clangNoLibc.cc;
        bintools = llvm_onBuildForTarget.bintools;
        useCcForLibs = false;
        inherit (buildPackages) coreutils gnugrep;
      });

in tillitis-cpu-stdenv.mkDerivation (finalAttrs: {
  pname = "tillitis-key1-firmware-softcpu";
  inherit (finalAttrs.src.passthru) version;

  src = callPackage ./src.nix { };

  # newer qemu (>=8.0.0) will fail if -DNOCONSOLE is used because it
  # expects the firmware to declare an HTIF range, which the
  # firmware won't do unless the console is enabled.
  postPatch = ''
    substituteInPlace Makefile --replace "-DNOCONSOLE" ""
  '';

  NIX_CFLAGS_LINK = "-fuse-ld=${llvm_onBuildForTarget.bintools}/bin/riscv32-none-elf-ld.lld";

  sourceRoot = "source/hw/application_fpga";

  hardeningDisable = [ "all" ];

  enableParallelBuilding = true;

  makeFlags = [
    "firmware.elf"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp firmware.elf $out/
    runHook postInstall
  '';

  dontFixup = true;

  meta = import ./meta.nix { inherit lib; } // {
    description = "Tillitis Key1 Soft-CPU Firmware";
  };
})



