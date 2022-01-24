{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles
, libiconv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "macchina";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x13ldPUr2PkrweDKyyQWMwd3PL4lsY11TIKrmBV5vkA=";
  };

  cargoSha256 = "sha256-y6UMpzt8uiN4jfYnDmwNFGQ1opUsQz8n870XY775qZo=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Foundation ];

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
