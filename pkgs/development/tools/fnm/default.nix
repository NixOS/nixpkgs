{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, DiskArbitration
, Foundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fnm";
<<<<<<< HEAD
  version = "1.35.1";
=======
  version = "1.33.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-qRnxXh3m/peMNAR/EV+lkwDI+Z6komF8GGFyF5UDOFg=";
=======
    sha256 = "sha256-dwnPFbgfrc+1qF3u5Nm1KQu84UWK6H6VerSUaQacbRs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation Security ];

<<<<<<< HEAD
  cargoHash = "sha256-//DCxAC8Jf7g8SkG4NfwkM0NyWUdASuw1g4COFIY0mU=";
=======
  cargoSha256 = "sha256-T88C5oYyVfepUw0cdNRhEwrvEI0t1gw/5qZL1E46pkY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd fnm \
      --bash <($out/bin/fnm completions --shell bash) \
      --fish <($out/bin/fnm completions --shell fish) \
      --zsh <($out/bin/fnm completions --shell zsh)
  '';

  meta = with lib; {
    description = "Fast and simple Node.js version manager";
    homepage = "https://github.com/Schniz/fnm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kidonng ];
  };
}
