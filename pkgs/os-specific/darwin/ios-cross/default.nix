{ runCommand
, lib
, llvm
, clang
, binutils
, stdenv
, coreutils
, gnugrep
, buildPackages
, hostPlatform
, targetPlatform
}:

/* As of this writing, known-good prefix/arch/simulator triples:
 * aarch64-apple-darwin14 | arm64  | false
 * arm-apple-darwin10     | armv7  | false
 * i386-apple-darwin11    | i386   | true
 * x86_64-apple-darwin14  | x86_64 | true
 */

let

  prefix = targetPlatform.config;
  inherit (targetPlatform) arch;
  simulator = targetPlatform.isiPhoneSimulator or false;

  sdkType = if simulator then "Simulator" else "OS";

  sdkVer = "10.2";

  sdk = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhone${sdkType}.platform/Developer/SDKs/iPhone${sdkType}${sdkVer}.sdk";

in (import ../../../build-support/cc-wrapper {
    inherit stdenv coreutils gnugrep runCommand buildPackages;
    nativeTools = false;
    nativeLibc = false;
    inherit binutils;
    libc = runCommand "empty-libc" {} "mkdir -p $out/{lib,include}";
    inherit (clang) cc;
    inherit hostPlatform targetPlatform;
    extraBuildCommands = ''
      if ! [ -d ${sdk} ]; then
          echo "You must have ${sdkVer} of the iPhone${sdkType} sdk installed at ${sdk}" >&2
          exit 1
      fi
      # ugh
      tr '\n' ' ' < $out/nix-support/cc-cflags > cc-cflags.tmp
      mv cc-cflags.tmp $out/nix-support/cc-cflags
      echo "-target ${prefix} -arch ${arch} -idirafter ${sdk}/usr/include ${if simulator then "-mios-simulator-version-min=7.0" else "-miphoneos-version-min=7.0"}" >> $out/nix-support/cc-cflags

      # Purposefully overwrite libc-ldflags-before, cctools ld doesn't know dynamic-linker and cc-wrapper doesn't do cross-compilation well enough to adjust
      echo "-arch ${arch} -L${sdk}/usr/lib ${lib.optionalString simulator "-L${sdk}/usr/lib/system "}-i${if simulator then "os_simulator" else "phoneos"}_version_min 7.0.0" > $out/nix-support/libc-ldflags-before
    '';
  }) // {
    inherit sdkType sdkVer sdk;
  }
