{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for sending desktop notifications";
    mainProgram = "nu_plugin_desktop_notifications";
    homepage = "https://github.com/FMotalleb/nu_plugin_desktop_notifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timon ];
    platforms = lib.platforms.linux;
  };
})
