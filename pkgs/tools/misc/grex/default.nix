{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "grex";
<<<<<<< HEAD
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = "grex";
    rev = "v${version}";
    hash = "sha256-ef1eUxeCznIgXLoywwJmnLkTGdW1AmGwCin9DLU9kAs=";
  };

  cargoHash = "sha256-XLH+fS3fwRcWmVOzTjUacV010N37Oofs9Tbixdka1qY=";
=======
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-of6mZ0SeiFXuXmvk64WoUNv6CLoj05K2kQpDQLMLwuY=";
  };

  cargoSha256 = "sha256-BS9K/1CyNYFwC/zQXEWZcSCjQyWgLgcVNbuyez2q/Ak=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/grex --help > /dev/null
  '';

  meta = with lib; {
    description = "A command-line tool for generating regular expressions from user-provided test cases";
    homepage = "https://github.com/pemistahl/grex";
<<<<<<< HEAD
    changelog = "https://github.com/pemistahl/grex/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "grex";
    maintainers = with maintainers; [ SuperSandro2000 mfrw ];
=======
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
