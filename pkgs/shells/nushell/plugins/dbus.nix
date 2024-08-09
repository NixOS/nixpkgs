{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  pkg-config,
  dbus,
}:
let
  version = "0.9.0";
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "nu-plugin-dbus";

  src = fetchFromGitHub {
    owner = "devyn";
    repo = "nu_plugin_dbus";
    rev = version;
    hash = "sha256-Bb55IO/qkQRVkPPyS0iYxYUw6qxhWMuaLj9oxK+I1fk=";
  };

  passthru.updateScript = gitUpdater { };

  cargoHash = "sha256-XmERSV2ihl2eS3PcT9hrP0PpTKiRic0Yz2UQyN+fqU8=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = [ dbus ];

  meta = with lib; {
    description = "Nushell plugin for interacting with D-Bus";
    homepage = "https://github.com/devyn/nu_plugin_dbus";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ darkkronicle ];
    mainProgram = "nu_plugin_dbus";
    platforms = with platforms; all;
  };
}
