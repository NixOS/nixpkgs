{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security, libiconv, Libsystem }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
<<<<<<< HEAD
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "procs";
    rev = "v${version}";
    hash = "sha256-DoH9XxPRKGd+tex8MdbtkhM+V8C1wDMv/GZcB4aMCPc=";
  };

  cargoHash = "sha256-B+LpUErsvtLYn+Xvq4KNBpLR9WYe38yMWHUNsd9jIs8=";

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/procs --gen-completion $shell
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    done
    installShellCompletion procs.{bash,fish} --zsh _procs
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv Libsystem ];

  meta = with lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    changelog = "https://github.com/dalance/procs/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ Br1ght0ne sciencentistguy ];
    mainProgram = "procs";
=======
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 sciencentistguy ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
