{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  runCommand,
  nushell,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_desktop_notifications";
  version = "0.105.1";

  src = fetchFromGitHub {
    owner = "FMotalleb";
    repo = "nu_plugin_desktop_notifications";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DLJHsZEe2KcIFcwr3S9rZSEDYLoU8JVAB6ibbhNLbvU=";
  };

  cargoHash = "sha256-M7j1V3rLk6PMDynOfHzzpZM/T4x/FZ550hHEUmUpBVE=";

  passthru = {
    updateScript = nix-update-script { };
    tests.check =
      let
        nu = lib.getExe nushell;
        plugin = lib.getExe finalAttrs.finalPackage;
      in
      runCommand "${finalAttrs.pname}-test" { } ''
        touch $out
        ${nu} -n -c "plugin add --plugin-config $out ${plugin}"
        ${nu} -n -c "plugin use --plugin-config $out desktop_notifications"
      '';
  };

  meta = {
    description = "Nushell plugin for sending desktop notifications";
    mainProgram = "nu_plugin_desktop_notifications";
    homepage = "https://github.com/FMotalleb/nu_plugin_desktop_notifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timon ];
    platforms = lib.platforms.linux;
  };
})
