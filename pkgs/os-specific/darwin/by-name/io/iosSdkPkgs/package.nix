{
  lib,
  binutils-unwrapped,
  clang-unwrapped,
  runCommand,
  stdenv,
  wrapBintoolsWith,
  wrapCCWith,

  buildPackages,
  targetPackages,
}:

let

  # Resolve xcodeVer from targetPackages (its hostPlatform is the iOS
  # crossSystem); buildPackages would fall back to the xcode_12_3 default.
  targetXcodeVer = targetPackages.stdenv.hostPlatform.xcodeVer or null;
  xcodeAttr =
    if targetXcodeVer != null then
      "xcode_${lib.replaceStrings [ "." ] [ "_" ] targetXcodeVer}"
    else
      "xcode";
  xcode = buildPackages.darwin.${xcodeAttr};

in

rec {
  sdk = rec {
    name = "ios-sdk";
    type = "derivation";
    # The unversioned iPhoneOS.sdk path is portable across minor Xcode bumps.
    outPath =
      xcode + "/Contents/Developer/Platforms/${platform}.platform/Developer/SDKs/${platform}.sdk";

    platform = stdenv.targetPlatform.xcodePlatform or "";
    # sdkVer = pre-rename lib/systems attr, kept for callers that haven't migrated.
    version = stdenv.targetPlatform.darwinSdkVersion or stdenv.targetPlatform.sdkVer or "";
  };

  binutils = wrapBintoolsWith {
    libc = libraries;
    bintools = binutils-unwrapped;
  };

  clang =
    let
      # Bake the deployment version into the triple or clang defaults to the
      # SDK's latest and LC_BUILD_VERSION mismatches at link time. Simulator
      # triples carry the version before the -simulator tag.
      isSimulator = stdenv.targetPlatform.isiOSSimulator or false;
      baseTriple =
        if isSimulator then
          lib.removeSuffix "-simulator" stdenv.targetPlatform.config
        else
          stdenv.targetPlatform.config;
      clangTarget =
        baseTriple
        + (stdenv.targetPlatform.darwinMinVersion or "")
        + (lib.optionalString isSimulator "-simulator");

      # cc-wrapper iterates extraPackages as derivations; wrap the SDK
      # subtrees we want propagated.
      sdkSystem = runCommand "ios-sdk-system" { } ''
        ln -s ${sdk}/System $out
      '';

      # Exports SDKROOT / DEVELOPER_DIR for tools that probe
      # `xcrun --show-sdk-path` (e.g. Rust's cc-rs) inside the sandbox.
      sdkHook = runCommand "ios-sdk-hook" { } ''
        mkdir -p $out/nix-support
        substitute ${./setup-hook.sh} $out/nix-support/setup-hook \
          --subst-var-by sdk "${sdk}" \
          --subst-var-by developerDir "${xcode}/Contents/Developer"
      '';
    in
    (wrapCCWith {
      cc = clang-unwrapped;
      bintools = binutils;
      libc = libraries;
      extraPackages = [
        sdkSystem
        sdkHook
      ];
      extraBuildCommands = ''
        tr '\n' ' ' < $out/nix-support/cc-cflags > cc-cflags.tmp
        mv cc-cflags.tmp $out/nix-support/cc-cflags
        echo "-target ${clangTarget}" >> $out/nix-support/cc-cflags
        echo "-isysroot ${sdk}" >> $out/nix-support/cc-cflags
        echo "-isystem ${sdk}/usr/include${lib.optionalString (lib.versionAtLeast "10" sdk.version) " -isystem ${sdk}/usr/include/c++/4.2.1/ -stdlib=libstdc++"}" >> $out/nix-support/cc-cflags
        ${lib.optionalString (lib.versionAtLeast sdk.version "14") "echo -isystem ${xcode}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1 >> $out/nix-support/cc-cflags"}
        # Full-path -fuse-ld: clang otherwise invokes /usr/bin/ld, which hangs
        # against a nix-store SDK; -B can't find our target-prefixed ld.
        # These stay in cc-cflags (not cc-ldflags) so hand-written configure
        # probes that invoke $CC directly still link with the wrapped ld.
        echo "-fuse-ld=${binutils}/bin/${stdenv.targetPlatform.config}-ld" >> $out/nix-support/cc-cflags
        echo "-Wno-unused-command-line-argument" >> $out/nix-support/cc-cflags
        echo "-L${sdk}/usr/lib" >> $out/nix-support/cc-cflags
      '';
    })
    // {
      inherit sdk;
    };

  libraries =
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
