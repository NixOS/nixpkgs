{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, libiconv
, Foundation
}:

rustPlatform.buildRustPackage rec {
  pname = "macchina";
  version = "6.1.8";

  src = fetchFromGitHub {
    owner = "Macchina-CLI";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MntHq5nphfjbO0Rx7v6WjsnabSMH5Ke3aR9/embG/rk=";
  };

  cargoHash = "sha256-w8WIpT8rUe7olB5kdpDyrId6D698AhcqzsfpOlutaHQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Foundation
  ];

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
