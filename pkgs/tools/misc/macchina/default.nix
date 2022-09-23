{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles
, libiconv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "macchina";
  version = "6.1.5";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-420Ng/LgmcYPH5q0boDaBjlWgLSeySXW/BTOp9+2XgA=";
  };

  cargoSha256 = "sha256-uRgHKj3EeT1Nq7j5koOovZJTVoVPVeBL8wLogJJoCfU=";

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
