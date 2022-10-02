{ lib, stdenv, makeWrapper, writeText, writeShellScriptBin, runCommand
, CoreServices, ImageIO, CoreGraphics
, runtimeShell, callPackage
, xcodePlatform ? stdenv.targetPlatform.xcodePlatform or "MacOSX"
, xcodeVer ? stdenv.targetPlatform.xcodeVer or "9.4.1"
, sdkVer ? stdenv.targetPlatform.darwinSdkVersion or "10.12" }:

let

  toolchainName = "com.apple.dt.toolchain.XcodeDefault";
  sdkName = "${xcodePlatform}${sdkVer}";
  xcrunSdkName = lib.toLower xcodePlatform;

  # TODO: expose MACOSX_DEPLOYMENT_TARGET in nix so we can use it here.
  sdkBuildVersion = "17E189";
  xcodeSelectVersion = "2349";

  xcbuild = callPackage ./default.nix {
    inherit CoreServices ImageIO CoreGraphics stdenv;
  };

  toolchains = callPackage ./toolchains.nix {
    inherit toolchainName stdenv;
  };

  sdks = callPackage ./sdks.nix {
    inherit toolchainName sdkName xcodePlatform;
    version = sdkVer;
  };

  platforms = callPackage ./platforms.nix {
    inherit sdks xcodePlatform stdenv;
  };

  xcconfig = writeText "nix.xcconfig" ''
    SDKROOT=${sdkName}
  '';

  xcode-select = writeText "xcode-select" ''
#!${runtimeShell}
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

  xcrun = writeShellScriptBin "xcrun" ''
args=( "$@" )

# If an SDK was requested, check that it matches.
for ((i = 0; i < ''${#args[@]}; i++)); do
  case "''${args[i]}" in
    --sdk | -sdk)
      i=$((i + 1))
      if [[ "''${args[i]}" != '${xcrunSdkName}' ]]; then
        echo >&2 "xcodebuild: error: SDK \"''${args[i]}\" cannot be located."
        exit 1
      fi
      ;;
  esac
done

while [ $# -gt 0 ]; do
   case "$1" in
         --sdk | -sdk) shift ;;
         --toolchain | -toolchain) shift ;;
         --find | -find | -f)
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
    inherit xcbuild xcrun;
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

  mkdir -p $out/Applications/Xcode.app/Contents
  ln -s $out $out/Applications/Xcode.app/Contents/Developer

  # The native xcodebuild command supports an invocation like "xcodebuild -version -sdk" without specifying the specific SDK, so we simulate this by
  # detecting this case and simulating the output; printing the header and appending the normal output via appending the sdk version to the positional
  # arguments we pass through to the wrapped xcodebuild.
  makeWrapper ${xcbuild}/bin/xcodebuild $out/bin/xcodebuild \
    --add-flags "-xcconfig ${xcconfig}" \
    --add-flags "DERIVED_DATA_DIR=." \
    --set DEVELOPER_DIR "$out" \
    --set SDKROOT ${sdkName} \
    --run '[ "$#" -eq 2 ] && [ "$1" = "-version" ] && [ "$2" = "-sdk" ] && echo ${sdkName}.sdk - macOS ${sdkVer} \(macosx${sdkVer}\) && set -- "$@" "${sdkName}"' \
    --run '[ "$1" = "-version" ] && [ "$#" -eq 1 ] && (echo Xcode ${xcodeVer}; echo Build version ${sdkBuildVersion}) && exit 0' \
    --run '[ "$1" = "-license" ] && exit 0'

  substitute ${xcode-select} $out/bin/xcode-select \
    --subst-var-by DEVELOPER_DIR $out/Applications/Xcode.app/Contents/Developer
  chmod +x $out/bin/xcode-select

  cp ${xcrun}/bin/xcrun $out/bin/xcrun

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
