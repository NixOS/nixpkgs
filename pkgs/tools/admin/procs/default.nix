{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv, Libsystem }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "procs";
    rev = "v${version}";
    hash = "sha256-Gx3HRGWi+t/wT1WrbuHXVyX+cP+JvZV8lBun1Qs8Xys=";
  };

  cargoHash = "sha256-0eLOAZnHbnvT8qgSfWO/RKXIdRr5wwfUQ9YQ77I6okQ=";

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
    mainProgram = "procs";
  };
}
