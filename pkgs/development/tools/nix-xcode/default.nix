{ stdenv, callPackage, runCommand, buildEnv, substituteAll, which }:

let
  script = s: substituteAll {
    src = s;
    isExecutable = true;
    inherit (stdenv) libc;
    inherit which;
    sdk = fakeSdk;
  };

  fakeSdk = runCommand "fake-sdk" {} ''
    mkdir -p $out/MacOSX10.10.sdk
    cat >$out/MacOSX10.10.sdk/SDKSettings.plist <<EOF
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>DefaultProperties</key>
      <dict>
        <key>PLATFORM_NAME</key>
        <string>macosx</string>
      </dict>
    </dict>
    </plist>
    EOF
  '';

in stdenv.mkDerivation {
  name = "nix-xcode-1.0";
  setupHook = ./setup-hook.sh;
  unpackPhase = ":";
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${script ./pkgutil.sh} $out/bin/pkgutil
    ln -s ${script ./xcode-select.sh} $out/bin/xcode-select
    ln -s ${script ./xcrun.sh} $out/bin/xcrun
    ln -s ${script ./xcodebuild.sh} $out/bin/xcodebuild
  '';
}
