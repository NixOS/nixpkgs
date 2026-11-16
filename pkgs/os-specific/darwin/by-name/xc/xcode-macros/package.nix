{
  lib,
  llvm,
  swift,
  xcode_27,
  runCommand,
}:

# This should be kept in sync with the SDK used by Swift in Nixpkgs.
runCommand "xcode-macros-27.0"
  {
    nativeBuildInputs = [ llvm ];
    meta = {
      description = "Swift macros shipped only with Xcode";
      homepage = "https://developer.apple.com";
      platforms = lib.platforms.darwin;
      license = lib.licenses.unfree;
      teams = [ lib.teams.swift ];
    };
  }
  ''
    pluginsPath=${lib.escapeShellArg xcode_27}/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib/swift/host/plugins/

    declare -a xcodeOnlyMacros=(
      libAppIntentsMacros.dylib
      libFoundationModelsMacros.dylib
      libPreviewsMacros.dylib
      libStateReportingMacros.dylib
      libSwiftDataMacros.dylib
      libSwiftUIMacros.dylib
      libTipKitMacros.dylib
    )
    declare -a macroDylibs=(''${xcodeOnlyMacros[@]/#/$pluginsPath})

    install -m644 -D -t "$out/lib/swift/host/plugins" "''${macroDylibs[@]}"

    # We can’t replace the rpath with the full path in the store because there’s not enough room.
    # Fortunately, there is enough room for `@loader_rpath/..`.
    ln -s ${lib.escapeShellArg swift.swiftc}/lib/swift/host/*.dylib "$out/lib/swift/host"
    for dylib in "$out/lib/swift/host/plugins"/*; do
      llvm-install-name-tool "$dylib" -rpath '/usr/lib/swift' '@loader_path/..'
    done
  ''
