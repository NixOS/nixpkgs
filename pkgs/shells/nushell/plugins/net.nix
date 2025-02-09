{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  IOKit,
  CoreFoundation,
  nix-update-script,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-nQILwEZaVL1xJ/CKGGObogFGPmW0UPq0v3vFP2kHqWo=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreFoundation
    IOKit
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Nushell plugin to list system network interfaces";
    homepage = "https://github.com/fennewald/nu_plugin_net";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "nu_plugin_net";
  };
}
