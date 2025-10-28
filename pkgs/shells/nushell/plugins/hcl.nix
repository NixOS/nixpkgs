{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_hcl";
  version = "0.108.0";

  src = fetchFromGitHub {
    owner = "Yethal";
    repo = "nu_plugin_hcl";
    tag = finalAttrs.version;
    hash = "sha256-WyZ8uSYWNzurqpE+BP0hKsknurP7Iyf5L8Y5DjVQZsA=";
  };

  cargoHash = "sha256-2b/0B9W01gGuGc482DYQSbRR2LLZXQxUG2fYB5TklPQ=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  # there are no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for parsing Hashicorp Configuration Language files";
    mainProgram = "nu_plugin_hcl";
    homepage = "https://github.com/Yethal/nu_plugin_hcl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yethal ];
  };
})
