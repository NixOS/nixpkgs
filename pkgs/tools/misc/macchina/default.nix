{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "macchina";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ICiU0emo5lEs6996TwkauuBWb2+Yy6lL+/x7zQgO470=";
  };

  cargoSha256 = "sha256-OfOh0YXeLT/kBuR9SOV7pHa8Z4b6+JvtVwqqwd1hCJY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion target/completions/*.{bash,fish}
  '';

  meta = with lib; {
    description = "A fast, minimal and customizable system information fetcher";
    homepage = "https://github.com/Macchina-CLI/macchina";
    changelog = "https://github.com/Macchina-CLI/macchina/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ _414owen ];
  };
}
