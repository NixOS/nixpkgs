{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  pkg-config,
  dbus,
  IOKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu-plugin-dbus";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = "nu_plugin_dbus";
    rev = version;
    hash = "sha256-XVLX0tCgpf5Vfr00kbQZPWMolzHpkMVYKoBHYylpz48=";
  };

  passthru.updateScript = gitUpdater { };

  cargoHash = "sha256-6/oG274QG8qq+rgtVtHlBkvaWYvzxuoPGCrHZNMwKzw=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  buildInputs =
    [ dbus ]
    ++ lib.optionals stdenv.isDarwin [
      IOKit
    ];

  meta = with lib; {
    description = "Nushell plugin for interacting with D-Bus";
    homepage = "https://github.com/devyn/nu_plugin_dbus";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ darkkronicle ];
    mainProgram = "nu_plugin_dbus";
    platforms = with platforms; all;
  };
}
