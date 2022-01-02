{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles
, libiconv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "macchina";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CInENUTuFyHGPntU1vv7c6MWZiCPdH3Zytj191Q/vOc=";
  };

  cargoSha256 = "sha256-XbNypI0x9lkLYIAk6X0Ifx/YV5yKmP6j2Qc+qQXMgjg=";

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
