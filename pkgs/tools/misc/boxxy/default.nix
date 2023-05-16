{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "boxxy";
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "queer";
    repo = "boxxy";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-I7VQfLCD+nfFllbns7yjYMl9hNwM8AgUbiHte4vMciM=";
  };

  cargoHash = "sha256-xtyiJZ9jPP2M0pUpMwQlUa9QgsRhFLqEm+hE3K4WO88=";
=======
    hash = "sha256-cXEoY9+no+WSp/VbbKl6q/mV5+B5d54kuIRfTtQUFc4=";
  };

  cargoHash = "sha256-PiX10Q3tYkVcbj3SX5MkaN1xQ/H7SCNpqTIgG+nJ6uo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = with lib; {
    description = "Puts bad Linux applications in a box with only their files";
    homepage = "https://github.com/queer/boxxy";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya figsoda ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
