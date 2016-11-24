{ runCommand
, lib
, llvm
, clang
, binutils
, stdenv
, coreutils
, gnugrep
}:

/* As of this writing, known-good prefix/arch/simulator triples:
 * aarch64-apple-darwin14 | arm64  | false
 * arm-apple-darwin10     | armv7  | false
 * i386-apple-darwin11    | i386   | true
 * x86_64-apple-darwin14  | x86_64 | true
 */

{ prefix, arch, simulator ? false }: let
  sdkType = if simulator then "Simulator" else "OS";

  sdk = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhone${sdkType}.platform/Developer/SDKs/iPhone${sdkType}10.0.sdk";

  /* TODO: Properly integrate with gcc-cross-wrapper */
  wrapper = import ../../../build-support/cc-wrapper {
    inherit stdenv coreutils gnugrep;
    nativeTools = false;
    nativeLibc = false;
    inherit binutils;
    libc = runCommand "empty-libc" {} "mkdir -p $out/{lib,include}";
    cc = clang;
    extraBuildCommands = ''
      # ugh
      tr '\n' ' ' < $out/nix-support/cc-cflags > cc-cflags.tmp
      mv cc-cflags.tmp $out/nix-support/cc-cflags
      echo "-target ${prefix} -arch ${arch} -idirafter ${sdk}/usr/include ${if simulator then "-mios-simulator-version-min=7.0" else "-miphoneos-version-min=7.0"}" >> $out/nix-support/cc-cflags

      # Purposefully overwrite libc-ldflags-before, cctools ld doesn't know dynamic-linker and cc-wrapper doesn't do cross-compilation well enough to adjust
      echo "-arch ${arch} -L${sdk}/usr/lib ${lib.optionalString simulator "-L${sdk}/usr/lib/system "}-i${if simulator then "os_simulator" else "phoneos"}_version_min 7.0.0" > $out/nix-support/libc-ldflags-before
    '';
  };
in {
  cc = runCommand "${prefix}-cc" {} ''
    mkdir -p $out/bin
    ln -sv ${wrapper}/bin/clang $out/bin/${prefix}-cc
    mkdir -p $out/nix-support
    echo ${llvm} > $out/nix-support/propagated-native-build-inputs
    cat > $out/nix-support/setup-hook <<EOF
    if test "\$dontSetConfigureCross" != "1"; then
        configureFlags="\$configureFlags --host=${prefix}"
    fi
    EOF
    fixupPhase
  '';

  binutils = runCommand "${prefix}-binutils" {} ''
    mkdir -p $out/bin
    ln -sv ${wrapper}/bin/ld $out/bin/${prefix}-ld
    for prog in ar nm ranlib; do
      ln -s ${binutils}/bin/$prog $out/bin/${prefix}-$prog
    done
    fixupPhase
  '';
}
