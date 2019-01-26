{ stdenv, lib, buildPackages, makeWrapper, writeText, runCommand
, CoreServices, ImageIO, CoreGraphics
, xcodePlatform ? stdenv.targetPlatform.xcodePlatform or "MacOSX"
, xcodeVer ? stdenv.targetPlatform.xcodeVer or "9.4.1"
, sdkVer ? stdenv.targetPlatform.sdkVer or "10.10" }:

let

  toolchainName = "com.apple.dt.toolchain.XcodeDefault";
  sdkName = "${xcodePlatform}${sdkVer}";

  # TODO: expose MACOSX_DEPLOYMENT_TARGET in nix so we can use it here.
  sdkBuildVersion = "17E189";
  xcodeSelectVersion = "2349";

  xcbuild = buildPackages.callPackage ./default.nix {
    inherit CoreServices ImageIO CoreGraphics;
  };

  toolchains = buildPackages.callPackage ./toolchains.nix {
    inherit toolchainName;
  };

  sdks = buildPackages.callPackage ./sdks.nix {
    inherit toolchainName sdkName xcodePlatform;
    version = sdkVer;
  };

  platforms = buildPackages.callPackage ./platforms.nix {
    inherit sdks xcodePlatform;
  };

  xcconfig = writeText "nix.xcconfig" ''
    SDKROOT=${sdkName}
  '';

  xcode-select = writeText "xcode-select" ''
#!${stdenv.shell}
while [ $# -gt 0 ]; do
   case "$1" in
         -h | --help) ;; # noop
         -s | --switch) shift;; # noop
         -r | --reset) ;; # noop
         -v | --version) echo xcode-select version ${xcodeSelectVersion} ;;
         -p | -print-path | --print-path) echo @DEVELOPER_DIR@ ;;
         --install) ;; # noop
    esac
    shift
done
  '';

  xcrun = writeText "xcrun" ''
#!${stdenv.shell}
while [ $# -gt 0 ]; do
   case "$1" in
         --sdk | -sdk) shift ;;
         --find | -find)
           shift
           command -v $1 ;;
         --log | -log) ;; # noop
         --verbose | -verbose) ;; # noop
         --no-cache | -no-cache) ;; # noop
         --kill-cache | -kill-cache) ;; # noop
         --show-sdk-path | -show-sdk-path)
           echo ${sdks}/${sdkName}.sdk ;;
         --show-sdk-platform-path | -show-sdk-platform-path)
           echo ${platforms}/${xcodePlatform}.platform ;;
         --show-sdk-version | -show-sdk-version)
           echo ${sdkVer} ;;
         --show-sdk-build-version | -show-sdk-build-version)
           echo ${sdkBuildVersion} ;;
         *) break ;;
    esac
    shift
done
if ! [[ -z "$@" ]]; then
   exec "$@"
fi
  '';

in

runCommand "xcodebuild-${xcbuild.version}" {
  nativeBuildInputs = [ makeWrapper ];
  inherit (xcbuild) meta;

  # ensure that the toolchain goes in PATH
  propagatedBuildInputs = [ "${toolchains}/XcodeDefault.xctoolchain" ];

  passthru = {
    inherit xcbuild;
    toolchain = "${toolchains}/XcodeDefault.xctoolchain";
    sdk = "${sdks}/${sdkName}";
    platform = "${platforms}/${xcodePlatform}.platform";
  };

  preferLocalBuild = true;
} ''
  mkdir -p $out/bin

  ln -s $out $out/usr

  mkdir -p $out/Library/Xcode
  ln -s ${xcbuild}/Library/Xcode/Specifications $out/Library/Xcode/Specifications

  ln -s ${platforms} $out/Platforms
  ln -s ${toolchains} $out/Toolchains

  makeWrapper ${xcbuild}/bin/xcodebuild $out/bin/xcodebuild \
    --add-flags "-xcconfig ${xcconfig}" \
    --add-flags "DERIVED_DATA_DIR=." \
    --set DEVELOPER_DIR "$out" \
    --set SDKROOT ${sdkName} \
    --run '[ "$1" = "-version" ] && [ "$#" -eq 1 ] && (echo Xcode ${xcodeVer}; echo Build version ${sdkBuildVersion}) && exit 0' \
    --run '[ "$1" = "-license" ] && exit 0'

  substitute ${xcode-select} $out/bin/xcode-select \
    --subst-var-by DEVELOPER_DIR $out
  chmod +x $out/bin/xcode-select

  substitute ${xcrun} $out/bin/xcrun
  chmod +x $out/bin/xcrun

  for bin in PlistBuddy actool builtin-copy builtin-copyPlist \
             builtin-copyStrings builtin-copyTiff \
             builtin-embeddedBinaryValidationUtility \
             builtin-infoPlistUtility builtin-lsRegisterURL \
             builtin-productPackagingUtility builtin-validationUtility \
             lsbom plutil; do
    ln -s ${xcbuild}/bin/$bin $out/bin/$bin
  done

  fixupPhase
''
