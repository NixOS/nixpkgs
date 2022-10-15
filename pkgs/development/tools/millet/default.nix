{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WWZi943PyWnm5TrFIWk/Lg/uQPWdfMuTQTxgNM9lF5w=";
  };

  cargoSha256 = "sha256-bHGDbHaMdQG+T1kA/clxDmnJblRYn2X7uVVF+MpvEGE=";

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
