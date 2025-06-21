{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "nushell_plugin_clipboard";
  version = "0.104.0-unstable-2025-05-05";

  src = fetchFromGitHub {
    repo = "nu_plugin_clipboard";
    owner = "FMotalleb";
    rev = "0f91062388d5bc3346325f6029c5fa3691715a76"; # No tag for nushell 0.104.0
    hash = "sha256-JUjZlWx2RtphrZhSX4Fgb8r9Y1kxs3HNt4CyuxpiDcA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-d0jmzKme0yZl9j/pgcZXYSUjUHZ7SaWM22Im1zcph2s=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  cargoBuildFlags = [ "--features use-wayland" ]; # Needed on wayland, will still be compatable with x11

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for interacting with the clipboard";
    longDescription = ''
      NOTE: Turning off the daemon may be needed for copy to work.
      More info can be found at the project's github.
      Issue mentioning the problem: https://github.com/FMotalleb/nu_plugin_clipboard/issues/1
      Project readme mentions the mitigation: https://github.com/FMotalleb/nu_plugin_clipboard
    '';
    mainProgram = "nu_plugin_clipboard";
    homepage = "https://github.com/FMotalleb/nu_plugin_clipboard";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldenparker ];
    platforms = lib.platforms.all;
  };
}
