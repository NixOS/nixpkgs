{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "teip";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "greymd";
    repo = "teip";
    rev = "52b7a8b4a6cbf354a3620936cec7add257e2f483";
    sha256 = "0s6ks6vdjrqri9cp48zgddjhmap9l81mygyrz6pa7xhcs48zaj23";
  };

  cargoSha256 = "165f9dxggyfagl3pb84hbi898yrwhdbmx4z52fh393a3s965nwpn";

  cargoPatches = [ ./Cargo.lock.patch ];

  nativeBuildInputs = [ installShellFiles ];

	# Disabling tests because criterion build was hanging for me
	# on Darwin
  doCheck = false;

  features = [ "oniguruma" ];

  preFixup = ''
    installManPage "$src/man/teip.1"

    installShellCompletion --zsh $src/completion/zsh/_teip
  '';

  meta = with lib; {
    description = "Highly efficient \"Masking tape\" for standard input";
    longDescription = ''
      Select partial standard input and replace with the result of another command efficiently
    '';
    homepage = "https://github.com/greymd/teip";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ greymd ];
    platforms = platforms.x86_64;
  };
}

