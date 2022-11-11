{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2fb7jt/wTDLFxRPzJ8i/JmlQvXBG9zjmE7nYBfmMis8=";
  };

  cargoSha256 = "sha256-JCO+IxDQeB3CTMpGD8D+1O7Vj2pBxvvnP9M48vVUEsc=";

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
