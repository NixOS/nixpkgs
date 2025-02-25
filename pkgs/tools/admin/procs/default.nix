{ lib, stdenv, buildPackages, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv, Libsystem }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.14.9";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "procs";
    rev = "v${version}";
    hash = "sha256-lm9bGu2AIVulVBcMzEpxxek5g6ajQmBENHeHV210g0k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bV59m59vEGvPYctD2pTPspH9zxSV2xg9J0QDGnXPUUA=";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  postInstall = ''
    for shell in bash fish zsh; do
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/procs --gen-completion $shell
    done
    installShellCompletion procs.{bash,fish} --zsh _procs
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security libiconv Libsystem ];

  meta = with lib; {
    description = "Modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    changelog = "https://github.com/dalance/procs/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne sciencentistguy ];
    mainProgram = "procs";
  };
}
