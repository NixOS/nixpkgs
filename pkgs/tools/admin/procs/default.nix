{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv, Libsystem }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lf+vJHR4+PZgoZNP4cSJswP0hi8YkUV85JISJxSjyjU=";
  };

  cargoSha256 = "sha256-evnUG94PagkgKoVwyd4aBaLXYYpF2k7zGhLRhdNDcoU=";

  nativeBuildInputs = [ installShellFiles ];

  LIBCLANG_PATH = lib.optionals stdenv.isDarwin "${stdenv.cc.cc.lib}/lib/";

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/procs --completion $shell
    done
    installShellCompletion procs.{bash,fish} --zsh _procs
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv Libsystem ];

  meta = with lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    changelog = "https://github.com/dalance/procs/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 sciencentistguy ];
  };
}
