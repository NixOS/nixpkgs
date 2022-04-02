{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hJe9JAUZZY2fx4I6+pVg1BYwzZrUWCkqPvQUT2OQXDo=";
  };

  cargoSha256 = "sha256-BChYzSnM9jnLioRhRDez6XOjJwGrU+giV4Ld3rp/57M=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/procs --completion $shell
    done
    installShellCompletion procs.{bash,fish} --zsh _procs
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  meta = with lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    changelog = "https://github.com/dalance/procs/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dalance Br1ght0ne SuperSandro2000 ];
  };
}
