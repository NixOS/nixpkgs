{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "flip-link";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-12eVZqW4+ZCDS0oszJI5rTREJY77km/y57LNDFJAwkk=";
  };

  cargoHash = "sha256-75D38+QjEzj7J4CC30iMeuDXwcW4QT9YWgYyCILSv+g=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  checkFlags = [
    # requires embedded toolchains
    "--skip should_link_example_firmware::case_1_normal"
    "--skip should_link_example_firmware::case_2_custom_linkerscript"
    "--skip should_verify_memory_layout"
  ];

  meta = with lib; {
    description = "Adds zero-cost stack overflow protection to your embedded programs";
    mainProgram = "flip-link";
    homepage = "https://github.com/knurling-rs/flip-link";
    changelog = "https://github.com/knurling-rs/flip-link/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      FlorianFranzen
      newam
    ];
  };
}
