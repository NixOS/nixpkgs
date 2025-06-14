{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

let
  version = "0.13.0";
in
rustPlatform.buildRustPackage {
  pname = "nu_plugin_emoji";
  inherit version;

  src = fetchFromGitHub {
    repo = "nu_plugin_emoji";
    owner = "fdncred";
    tag = "v${version}";
    hash = "sha256-PC6ALLp/PWDbtoxMfx3JuEJXvRm1a49k7+I1L0sDdN8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BFWFmTQvqJXUZ2bYBsVNt6ErkCAls0R5HMah7VWZcCQ=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin that makes finding and printing emojis easy";
    mainProgram = "nu_plugin_emoji";
    homepage = "https://github.com/fdncred/nu_plugin_emoji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldenparker ];
    platforms = lib.platforms.all;
  };
}
