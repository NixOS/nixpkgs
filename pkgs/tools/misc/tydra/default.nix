{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "tydra";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Mange";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kvyski3qy2lwlpipynq894i0g9x2j4a1iy2mgdwfibfyfkv2jnm";
  };

  cargoSha256 = "0handd5vxxvmlllzxhvwgadl4r7yc78f068r8jryprpap31azg3a";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/{tydra.1,tydra-actions.5}

    $out/bin/tydra --generate-completions bash > tydra.bash
    $out/bin/tydra --generate-completions fish > tydra.fish
    $out/bin/tydra --generate-completions zsh > _tydra

    installShellCompletion tydra.{bash,fish} _tydra
  '';

  meta = with lib; {
    description = "Shortcut menu-based task runner, inspired by Emacs Hydra";
    homepage = "https://github.com/Mange/tydra";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "tydra";
  };
}
