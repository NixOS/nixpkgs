{ lib, stdenv, rustPlatform, fetchFromGitHub, installShellFiles
, libiconv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "macchina";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = pname;
    rev = "v${version}";
    sha256 = "04ya8sa0qhj0g3h5fi5fmx0xg1glg993xad4glfm317spgkff6z7";
  };

  cargoSha256 = "1gch2742zv0f23mq8ppmi75lmjj5m3s14wlsr72nd8hyn3ff7kbw";

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
