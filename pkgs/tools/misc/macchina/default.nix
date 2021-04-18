{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "macchina";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-y23gpYDnYoiTJcNyWKslVenPTXcCrOvxq+0N9PjQN3g=";
  };

  cargoSha256 = "sha256-jfLj8kLBG6AeeYo421JCl1bMqWwOGiwQgv7AEomtFcY=";

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
