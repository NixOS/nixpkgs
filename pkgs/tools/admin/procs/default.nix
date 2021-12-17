{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.11.12";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O2jH56l4SCYF+9oNhviJdybKmUo/iuR5mOOugc4Hw6Y=";
  };

  cargoSha256 = "sha256-MrYOOAFj+mVm/EPx4CGQI7YhxPcF0jBgnnJk/DV2ojk=";

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
