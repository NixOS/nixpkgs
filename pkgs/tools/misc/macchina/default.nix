{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles
, libiconv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "macchina";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:0d6nqjn2828kk91430yjl6xlwx1j10xhp2i0vv2slm3wv0a4w24x";
  };

  cargoSha256 = "sha256:0mjqqd43jj6hxicgjkvmdf966vj5xf0ndibszzwp38zdb5kzshqi";

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
