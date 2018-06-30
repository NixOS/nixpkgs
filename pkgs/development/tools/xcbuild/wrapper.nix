{ stdenv, buildPackages, makeWrapper, writeText, runCommand
, CoreServices, ImageIO, CoreGraphics }:

let

  toolchainName = "com.apple.dt.toolchain.XcodeDefault";
  platformName = "com.apple.platform.macosx";
  sdkName = "macosx10.10";

  xcbuild = buildPackages.callPackage ./default.nix {
    inherit CoreServices ImageIO CoreGraphics;
  };

  toolchain = buildPackages.callPackage ./toolchain.nix {
    inherit toolchainName;
  };

  sdk = buildPackages.callPackage ./sdk.nix {
    inherit toolchainName sdkName;
  };

  platform = buildPackages.callPackage ./platform.nix {
    inherit sdk platformName;
  };

  xcconfig = writeText "nix.xcconfig" ''
    SDKROOT=${sdkName}
  '';

in

stdenv.mkDerivation {
  name = "xcbuild-wrapper-${xcbuild.version}";

  nativeBuildInputs = [ makeWrapper ];

  setupHook = ./setup-hook.sh;

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin

    for file in ${xcbuild}/bin/*; do
      ln -s $file $out/bin
    done

    mkdir -p $out/usr
    ln -s $out/bin $out/usr/bin

    mkdir -p $out/Library/Xcode
    ln -s ${xcbuild}/Library/Xcode/Specifications $out/Library/Xcode/Specifications

    mkdir -p $out/Platforms
    ln -s ${platform} $out/Platforms/nixpkgs.platform

    mkdir -p $out/Toolchains
    ln -s ${toolchain} $out/Toolchains/nixpkgs.xctoolchain

    wrapProgram $out/bin/xcodebuild \
      --add-flags "-xcconfig ${xcconfig}" \
      --add-flags "DERIVED_DATA_DIR=." \
      --set DEVELOPER_DIR "$out" \
      --set SDKROOT ${sdkName}
    wrapProgram $out/bin/xcrun \
      --set DEVELOPER_DIR "$out" \
      --set SDKROOT ${sdkName}
    wrapProgram $out/bin/xcode-select \
      --set DEVELOPER_DIR "$out" \
      --set SDKROOT ${sdkName}
  '';

  inherit (xcbuild) meta;

  passthru = {
    raw = xcbuild;
  };

  preferLocalBuild = true;
}
