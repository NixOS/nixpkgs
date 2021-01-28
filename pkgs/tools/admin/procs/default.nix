{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e9fdqsv/P3zZdjsdAkwO21txPS1aWd0DuqRQUdr1vX4=";
  };

  cargoSha256 = "sha256-ilSDLbPQnmhQcNbtKCpUNmyZY0JUY/Ksg0sj/t7veT0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/procs --completion $shell > procs.$shell
      installShellCompletion procs.$shell
    done
  '';

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers; [ dalance Br1ght0ne ];
    platforms = with platforms; linux ++ darwin;
  };
}
