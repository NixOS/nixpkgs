{ lib, hostPlatform, targetPlatform
, clang-unwrapped
, binutils-unwrapped
, runCommand
, stdenv
, wrapBintoolsWith
, wrapCCWith
, buildIosSdk, targetIosSdkPkgs
}:

let

minSdkVersion = "9.0";

iosPlatformArch = { parsed, ... }: {
  "arm"     = "armv7";
  "aarch64" = "arm64";
  "x86_64"  = "x86_64";
}.${parsed.cpu.name};

in

rec {
  # TODO(kmicklas): Make a pure version of this for each supported SDK version.
  sdk = rec {
    name = "ios-sdk";
    type = "derivation";
    outPath = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhone${sdkType}.platform/Developer/SDKs/iPhone${sdkType}${version}.sdk";

    sdkType = if targetPlatform.isiPhoneSimulator then "Simulator" else "OS";
    version = targetPlatform.sdkVer;
  };

  binutils = wrapBintoolsWith {
    libc = targetIosSdkPkgs.libraries;
    bintools = binutils-unwrapped;
    extraBuildCommands = ''
      echo "-arch ${iosPlatformArch targetPlatform}" >> $out/nix-support/libc-ldflags
    '';
  };

  clang = (wrapCCWith {
    cc = clang-unwrapped;
    bintools = binutils;
    libc = targetIosSdkPkgs.libraries;
    extraBuildCommands = ''
      tr '\n' ' ' < $out/nix-support/cc-cflags > cc-cflags.tmp
      mv cc-cflags.tmp $out/nix-support/cc-cflags
      echo "-target ${targetPlatform.config} -arch ${iosPlatformArch targetPlatform}" >> $out/nix-support/cc-cflags
      echo "-isystem ${sdk}/usr/include -isystem ${sdk}/usr/include/c++/4.2.1/ -stdlib=libstdc++" >> $out/nix-support/cc-cflags
      echo "${if targetPlatform.isiPhoneSimulator then "-mios-simulator-version-min" else "-miphoneos-version-min"}=${minSdkVersion}" >> $out/nix-support/cc-cflags
    '';
  }) // {
    inherit sdk;
  };

  libraries = let sdk = buildIosSdk; in runCommand "libSystem-prebuilt" {
    passthru = {
      inherit sdk;
    };
  } ''
    if ! [ -d ${sdk} ]; then
        echo "You must have version ${sdk.version} of the iPhone${sdk.sdkType} sdk installed at ${sdk}" >&2
        exit 1
    fi
    ln -s ${sdk}/usr $out
  '';
}
