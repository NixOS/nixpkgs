{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv, Libsystem }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "procs";
    rev = "v${version}";
    hash = "sha256-9kxJrvlaEoEkPPoU4/9IlX2TvDUG9VZwtb4a3N9rAsc=";
  };

  cargoHash = "sha256-2g+6FmcO4t9tjLq7xkBaLAgbzQoBgskr8csM/1tHbWI=";

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
