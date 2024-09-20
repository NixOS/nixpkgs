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
  #
  # See comments in cc-wrapper's setup hook. This works exactly the same way.
  #
  [[ -z \''${strictDeps-} ]] || (( "\$hostOffset" < 0 )) || return 0

  sdkRootHook() {
    # See ../../../build-support/setup-hooks/role.bash
    local role_post
    getHostRoleEnvHook

    # Only set the SDK root if one has not been set via this hook or some other means.
    if [[ ! \$NIX_CFLAGS_COMPILE =~ isysroot ]]; then
      export NIX_CFLAGS_COMPILE\''${role_post}+=' -isysroot $out/${sdkName}.sdk'
    fi
  }

  # See ../../../build-support/setup-hooks/role.bash
  getTargetRole

  addEnvHooks "\$targetOffset" sdkRootHook

  # No local scope in sourced file
  unset -v role_post
  hook
''
