{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  IOKit,
  CoreFoundation,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_net";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "fennewald";
    repo = "nu_plugin_net";
    rev = "refs/tags/${version}";
    hash = "sha256-nKcB919M9FkDloulh9IusWYPhf8vlhUmKVs6Gd6w3Bw=";
  };

  cargoHash = "sha256-3FMalpgKYZ4xM2fHXTFOVu5I8yS06K1bDiKg4we7jF4=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreFoundation
    IOKit
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Nushell plugin to list system network interfaces";
    homepage = "https://github.com/fennewald/nu_plugin_net";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "nu_plugin_net";
  };
}
