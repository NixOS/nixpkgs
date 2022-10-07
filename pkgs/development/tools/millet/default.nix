{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fi0kU1+gazSfQEyL3qYcK/qeMh1UGuitGXJ9FsVAiTw=";
  };

  cargoSha256 = "sha256-ijXGXq5+OOnf4Nmg68GcSKZe/5tjG0KebOsCWU+vmHc=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoBuildFlags = [ "--package" "lang-srv" ];

  cargoTestFlags = [ "--package" "lang-srv" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/changelog.md";
    license = [ licenses.mit /* or */ licenses.asl20 ];
    maintainers = with maintainers; [ marsam ];
    mainProgram = "lang-srv";
  };
}
