{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_highlight";
  version = "1.3.1+0.98.0";

  src = fetchFromGitHub {
    repo = "nu-plugin-highlight";
    owner = "cptpiepmatz";
    rev = "v${version}";
    hash = "sha256-G669d13JBLdy/1RUXtgZkiQhjgn3SqV34VlLbQoVOzc=";
  };
  cargoHash = "sha256-ZZyxRiAaazLIwWtl9f30yp94HiKao3ZlYJ6B/vK14jc=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = [ ];
  cargoBuildFlags = [ "--package nu_plugin_highlight" ];

  checkPhase = ''
    cargo test
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A nushell plugin that will inspect a file and return information based on it's magic number.";
    mainProgram = "nu_plugin_highlight";
    homepage = "https://github.com/cptpiepmatz/nu-plugin-highlight";
    license = licenses.mit;
    maintainers = with maintainers; [ mgttlinger ];
    platforms = with platforms; all;
  };
}
