{ targetPlatform
, clang-unwrapped
, binutils-unwrapped
, runCommand
, stdenv
, wrapBintoolsWith
, wrapCCWith
, buildIosSdk, targetIosSdkPkgs
, xcode
, lib
}:

let

minSdkVersion = "9.0";

iosPlatformArch = { parsed, ... }: {
  armv7a  = "armv7";
  aarch64 = "arm64";
  x86_64  = "x86_64";
}.${parsed.cpu.name};

in

rec {
  sdk = rec {
    name = "ios-sdk";
    type = "derivation";
    outPath = xcode + "/Contents/Developer/Platforms/${platform}.platform/Developer/SDKs/${platform}${version}.sdk";

    platform = targetPlatform.xcodePlatform;
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
    extraPackages = [ "${sdk}/System" ];
    extraBuildCommands = ''
      tr '\n' ' ' < $out/nix-support/cc-cflags > cc-cflags.tmp
      mv cc-cflags.tmp $out/nix-support/cc-cflags
      echo "-target ${targetPlatform.config} -arch ${iosPlatformArch targetPlatform}" >> $out/nix-support/cc-cflags
      echo "-isystem ${sdk}/usr/include${lib.optionalString (lib.versionAtLeast "10" sdk.version) " -isystem ${sdk}/usr/include/c++/4.2.1/ -stdlib=libstdc++"}" >> $out/nix-support/cc-cflags
    '' + stdenv.lib.optionalString (sdk.platform == "iPhoneSimulator") ''
      echo "-mios-simulator-version-min=${minSdkVersion}" >> $out/nix-support/cc-cflags
    '' + stdenv.lib.optionalString (sdk.platform == "iPhoneOS") ''
      echo "-miphoneos-version-min=${minSdkVersion}" >> $out/nix-support/cc-cflags
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
        echo "You must have version ${sdk.version} of the ${sdk.platform} sdk installed at ${sdk}" >&2
        exit 1
    fi
    ln -s ${sdk}/usr $out
  '';
}
