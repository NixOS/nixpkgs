{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OaHsNxrOrPlAwtFDY3Tnx+nOabax98xcGQeNds32iOA=";
  };

  cargoSha256 = "sha256-miOfm1Sw6tIICkT9T2V82cdGG2STo9vuLPWsAN/8wuM=";

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
