{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv, Libsystem }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PTUATmnpJGeY0Ushf7sAapsZ51VC2IdnKMzYJX5+h9A=";
  };

  cargoHash = "sha256-jxGdozSEIop2jBL4lK3ZcEuuR7P8qDoQD/Lrl4yaBN0=";

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
