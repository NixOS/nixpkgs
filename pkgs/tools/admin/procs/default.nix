{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.11.8";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZeCTUoi2HAMUeyze7LdxH0mi1Dd6q8Sw6+xPAVf3HTs=";
  };

  cargoSha256 = "sha256-8myay5y4PGb/8s0vPLeg9xt6xqAQxGFXJz/GiV0ABlA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/procs --completion $shell > procs.$shell
      installShellCompletion procs.$shell
    done
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  meta = with lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers; [ dalance Br1ght0ne ];
    platforms = with platforms; linux ++ darwin;
  };
}
