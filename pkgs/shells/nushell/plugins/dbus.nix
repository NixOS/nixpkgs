{
  stdenv,
  runCommand,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
  dbus,
  nushell,
  nushell_plugin_dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_dbus";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = "nu_plugin_dbus";
    tag = finalAttrs.version;
    hash = "sha256-Ga+1zFwS/v+3iKVEz7TFmJjyBW/gq6leHeyH2vjawto=";
  };

  cargoHash = "sha256-7pD5LA1ytO7VqFnHwgf7vW9eS3olnZBgdsj+rmcHkbU=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = [ dbus ];

  passthru = {
    updateScript = nix-update-script { };
    tests.check =
      let
        nu = lib.getExe nushell;
        plugin = lib.getExe nushell_plugin_dbus;
      in
      runCommand "${finalAttrs.pname}-test" { } ''
        touch $out
        ${nu} -n -c "plugin add --plugin-config $out ${plugin}"
        ${nu} -n -c "plugin use --plugin-config $out dbus"
      '';
  };

  meta = {
    description = "Nushell plugin for communicating with D-Bus";
    mainProgram = "nu_plugin_dbus";
    homepage = "https://github.com/devyn/nu_plugin_dbus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aftix ];
    platforms = lib.platforms.linux;
  };
})
