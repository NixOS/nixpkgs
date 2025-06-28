{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
  dbus,
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for communicating with D-Bus";
    mainProgram = "nu_plugin_dbus";
    homepage = "https://github.com/devyn/nu_plugin_dbus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aftix ];
    platforms = lib.platforms.linux;
    # "Plugin `dbus` is compiled for nushell version 0.101.0, which is not
    # compatible with version 0.105.1"
    broken = true;
  };
})
