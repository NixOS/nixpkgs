{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZvLpLQ7WkRvApSZ7vPDmQH8iLLpKUEY5ig5Mn+rkMI8=";
  };

  cargoSha256 = "sha256-I5JgtW5Bgz2swJYiY2gV1UbSgeGxef7Hb4gDQYz/0TU=";

  cargoBuildFlags = [ "--package" "lang-srv" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
