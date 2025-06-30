{
  stdenv,
  clang-unwrapped,
  binutils-unwrapped,
  runCommand,

  wrapBintoolsWith,
  wrapCCWith,
  buildIosSdk,
  targetIosSdkPkgs,
  xcode,
  lib,
}:

let

  minSdkVersion = stdenv.targetPlatform.minSdkVersion or "9.0";

in

rec {
  sdk = rec {
    name = "ios-sdk";
    type = "derivation";
    outPath =
      xcode
      + "/Contents/Developer/Platforms/${platform}.platform/Developer/SDKs/${platform}${version}.sdk";

    platform = stdenv.targetPlatform.xcodePlatform or "";
    version = stdenv.targetPlatform.sdkVer or "";
  };

  binutils = wrapBintoolsWith {
    libc = targetIosSdkPkgs.libraries;
    bintools = binutils-unwrapped;
  };

  clang =
    (wrapCCWith {
      cc = clang-unwrapped;
      bintools = binutils;
      libc = targetIosSdkPkgs.libraries;
      extraPackages = [ "${sdk}/System" ];
      extraBuildCommands = ''
        tr '\n' ' ' < $out/nix-support/cc-cflags > cc-cflags.tmp
        mv cc-cflags.tmp $out/nix-support/cc-cflags
        echo "-target ${stdenv.targetPlatform.config}" >> $out/nix-support/cc-cflags
        echo "-isystem ${sdk}/usr/include${lib.optionalString (lib.versionAtLeast "10" sdk.version) " -isystem ${sdk}/usr/include/c++/4.2.1/ -stdlib=libstdc++"}" >> $out/nix-support/cc-cflags
        ${lib.optionalString (lib.versionAtLeast sdk.version "14") "echo -isystem ${xcode}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1 >> $out/nix-support/cc-cflags"}
      '';
    })
    // {
      inherit sdk;
    };

  libraries =
    let
      sdk = buildIosSdk;
    in
    runCommand "libSystem-prebuilt"
      {
        passthru = {
          inherit sdk;
        };
      }
      ''
        if ! [ -d ${sdk} ]; then
            echo "You must have version ${sdk.version} of the ${sdk.platform} sdk installed at ${sdk}" >&2
            exit 1
        fi
        ln -s ${sdk}/usr $out
      '';
}
