{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/xq1aLdr672v4iAXXLcu47QcsdbLErn3VN/w3sYo9y0=";
  };

  cargoSha256 = "sha256-BykfUGKBiqr3DoYcqKpY3R84LAuJ19D94xnZcQGKwuI=";

  nativeBuildInputs = [ installShellFiles ];

  LIBCLANG_PATH = lib.optionals stdenv.isDarwin "${stdenv.cc.cc.lib}/lib/";

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
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 sciencentistguy ];
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
