{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RTOFwgs9A7ESWT8g5EcVzmv9UGON/+cNj21VC8bURlk=";
  };

  cargoSha256 = "sha256-/yUyvFTaoQQ4Ttlp1IHye9Iu7iD2W/yhuHKC3Seu6k0=";

  cargoBuildFlags = [ "--package" "lang-srv" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/changelog.md";
    license = [ licenses.mit /* or */ licenses.asl20 ];
    maintainers = with maintainers; [ marsam ];
  };
}
