{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage {
  pname = "nu_plugin_desktop_notifications";
  version = "1.2.11-unstable-2025-05-05";

  src = fetchFromGitHub {
    repo = "nu_plugin_desktop_notifications";
    owner = "FMotalleb";
    rev = "de4464bf6ce6503977ee2bd41f11aeabc49214aa"; # No tag for nushell 0.104.0
    hash = "sha256-ZQ1zOYcGTfHhRAnDxVxcZ740yF2nccIOWL+yuShhs0Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DrHWdwljPsPkzbM9mok5x7gn6Op1ytwg67+HtcZg8G8=";

  nativeBuildInputs =
    [ pkg-config ]
    ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ writableTmpDirAsHomeHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for sending desktop notifications using notify-rust";
    mainProgram = "nu_plugin_desktop_notifications";
    homepage = "https://github.com/FMotalleb/nu_plugin_desktop_notifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldenparker ];
    platforms = lib.platforms.all;
  };
}
