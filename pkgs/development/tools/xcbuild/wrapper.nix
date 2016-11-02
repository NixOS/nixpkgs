{ stdenv, callPackage, makeWrapper, writeText, CoreServices, ImageIO, CoreGraphics
, cctools, bootstrap_cmds}:

let

  toolchainName = "com.apple.dt.toolchain.XcodeDefault";
  platformName = "com.apple.platform.macosx";
  sdkName = "macosx10.9";

  xcbuild = callPackage ./default.nix {
    inherit CoreServices ImageIO CoreGraphics;
  };

  toolchain = callPackage ./toolchain.nix {
    inherit cctools bootstrap_cmds toolchainName xcbuild;
    cc = stdenv.cc;
  };

  sdk = callPackage ./sdk.nix {
    inherit toolchainName sdkName xcbuild;
  };

  platform = callPackage ./platform.nix {
    inherit sdk platformName xcbuild;
  };

  developer = callPackage ./developer.nix {
    inherit platform toolchain xcbuild;
  };

  xcconfig = writeText "nix.xcconfig" ''
SDKROOT=${sdkName}
  '';

in

stdenv.mkDerivation {
  name = "xcbuild-wrapper";

  buildInputs = [ xcbuild makeWrapper ];

  setupHook = ./setup-hook.sh;

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cd $out/bin/

    for file in ${xcbuild}/bin/*; do
      ln -s $file
    done

    wrapProgram $out/bin/xcodebuild \
      --add-flags "-xcconfig ${xcconfig}" \
      --add-flags "DERIVED_DATA_DIR=." \
      --set DEVELOPER_DIR "${developer}"
    wrapProgram $out/bin/xcrun \
      --add-flags "-sdk ${sdkName}" \
      --set DEVELOPER_DIR "${developer}"
  '';

  passthru = {
    raw = xcbuild;
  };

  preferLocalBuild = true;
}
