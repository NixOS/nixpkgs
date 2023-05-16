{ lib
, rustPlatform
, fetchCrate
, stdenv
, Security
, withLsp ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "taplo";
<<<<<<< HEAD
  version = "0.8.1";
=======
  version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchCrate {
    inherit version;
    pname = "taplo-cli";
<<<<<<< HEAD
    sha256 = "sha256-evNW6OA7rArj0TvOaQgktcQy0tWnel3ZL+ic78e6lOk=";
  };

  cargoSha256 = "sha256-jeLjoqEieR96mUZQmQtv7P78lmOaF18ruVhZLi/TieQ=";
=======
    sha256 = "sha256-od8uL2xvIGFtftob3P0VQ+SPkwQgU68OxS6hk34c4+U=";
  };

  cargoSha256 = "sha256-1ba0FqegYNbRis7Nwl2RONHOxq0iuLah8a1QlWs4HfE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optional stdenv.isDarwin Security;

  buildFeatures = lib.optional withLsp "lsp";

  meta = with lib; {
    description = "A TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
<<<<<<< HEAD
    mainProgram = "taplo";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
