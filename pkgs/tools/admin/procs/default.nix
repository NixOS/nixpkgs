{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv, Libsystem }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "procs";
    rev = "v${version}";
    hash = "sha256-DoH9XxPRKGd+tex8MdbtkhM+V8C1wDMv/GZcB4aMCPc=";
  };

  cargoHash = "sha256-B+LpUErsvtLYn+Xvq4KNBpLR9WYe38yMWHUNsd9jIs8=";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/procs --gen-completion $shell
    done
    installShellCompletion procs.{bash,fish} --zsh _procs
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv Libsystem ];

  meta = with lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    changelog = "https://github.com/dalance/procs/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne sciencentistguy ];
  };
}
