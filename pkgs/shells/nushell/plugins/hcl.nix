{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_hcl";
  version = "0.104.1";

  src = fetchFromGitHub {
    repo = "nu_plugin_hcl";
    owner = "Yethal";
    tag = version;
    hash = "sha256-AGTrSLVzbnzMQ2oUuD8Lq4phRt404lSRPiU8Oh9KBG0=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-5bxE+wN3uAbJSIh0wFS/KA5iTyFiSvFWmj14S/Fmkec=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  cargoBuildFlags = [ "--package nu_plugin_hcl" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Nushell plugin for parsing Hashicorp Configuration Language files";
    mainProgram = "nu_plugin_hcl";
    homepage = "https://github.com/Yethal/nu_plugin_hcl";
    license = licenses.mit;
    maintainers = with maintainers; [ yethal ];
    platforms = with platforms; all;
  };
}
