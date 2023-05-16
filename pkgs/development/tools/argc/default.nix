<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "1.9.0";
=======
{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "argc";
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BM9MXokVXA5EJwr8F7Wg5LTE1xhmj9ttVXOMNJx0RRw=";
  };

  cargoHash = "sha256-SScCPBERXScYJ9LlPcbIhwCikRum0F1tU3gZYaQRFTo=";
=======
    hash = "sha256-lZtAhsEfMzj8Irl7LQPzjBNiKKy8091p2XoB5wSPhKM=";
  };

  cargoHash = "sha256-L0FX4RuJ5n76CCWVpGQryX7usXGBN55W9+y83s9JJug=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd argc \
      --bash <($out/bin/argc --argc-completions bash) \
      --fish <($out/bin/argc --argc-completions fish) \
      --zsh <($out/bin/argc --argc-completions zsh)
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "A command-line options, arguments and sub-commands parser for bash";
=======
    description = "A tool to handle sh/bash cli parameters";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/sigoden/argc";
    changelog = "https://github.com/sigoden/argc/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
