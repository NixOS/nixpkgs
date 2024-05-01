{
  lib,
  runCommand,
  writeText,
  sdkVersion,
}:

let
  sdkName = "MacOSX${sdkVersion}";
  toolchainName = "com.apple.dt.toolchain.XcodeDefault";
  productBuildVer = null;

  inherit (lib.generators) toPlist toJSON;

  SDKSettings = {
    CanonicalName = "macosx${sdkVersion}";
    DisplayName = "macOS ${sdkVersion}";
    Toolchains = [ toolchainName ];
    Version = sdkVersion;
    MaximumDeploymentTarget = "${sdkVersion}.99";
    isBaseSDK = "YES";
  };

  SystemVersion =
    lib.optionalAttrs (productBuildVer != null) { ProductBuildVersion = productBuildVer; }
    // {
      ProductName = "macOS";
      ProductVersion = sdkVersion;
    };
in
runCommand "sdkroot-${sdkVersion}" { } ''
  sdk="$out/${sdkName}.sdk"

  install -D ${writeText "SDKSettings.plist" (toPlist { } SDKSettings)} "$sdk/SDKSettings.plist"
  install -D ${writeText "SDKSettings.json" (toJSON { } SDKSettings)} "$sdk/SDKSettings.json"
  install -D ${
    writeText "SystemVersion.plist" (toPlist { } SystemVersion)
  } "$sdk/System/Library/CoreServices/SystemVersion.plist"

  ln -s "$sdk" "$sdk/usr"

  install -D '${../../../build-support/setup-hooks/role.bash}' "$out/nix-support/setup-hook"
  cat >> "$out/nix-support/setup-hook" <<-hook
  sdkRootHook() {
    # See ../../../build-support/setup-hooks/role.bash
    local role_post
    getHostRoleEnvHook

    # Only set the SDK root if one has not been set via this hook or some other means.
    local cflagsVar=NIX_CFLAGS_COMPILE\''${role_post}
    if [[ ! \''${!cflagsVar} =~ isysroot ]]; then
      export NIX_CFLAGS_COMPILE\''${role_post}+=' -isysroot $out/${sdkName}.sdk'
    fi
  }

  # See ../../../build-support/setup-hooks/role.bash
  getTargetRole

  addEnvHooks "\$hostOffset" sdkRootHook

  # No local scope in sourced file
  unset -v cflagsVar role_post
  hook
''
