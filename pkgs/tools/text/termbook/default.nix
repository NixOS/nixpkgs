<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, oniguruma
, stdenv
, darwin
}:
=======
{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

rustPlatform.buildRustPackage rec {
  pname = "termbook-cli";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "termbook";
    rev = "v${version}";
    sha256 = "Bo3DI0cMXIfP7ZVr8MAW/Tmv+4mEJBIQyLvRfVBDG8c=";
  };

<<<<<<< HEAD
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  # update dependencies to fix build failure caused by unaligned packed structs
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  postInstall = ''
    installShellCompletion --cmd termbook \
      --bash <($out/bin/termbook completions bash) \
      --fish <($out/bin/termbook completions fish) \
      --zsh <($out/bin/termbook completions zsh)
  '';

=======
  cargoSha256 = "sha256-9fFvJJlDzBmbI7hes/wfjAk1Cl2H55T5n8HLnUmDw/c=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A runner for `mdbooks` to keep your documentation tested";
    homepage = "https://github.com/Byron/termbook/";
    changelog = "https://github.com/Byron/termbook/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ phaer ];
  };
}
