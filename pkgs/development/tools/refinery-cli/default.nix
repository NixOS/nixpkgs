{ fetchCrate, lib, openssl, pkg-config, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "refinery-cli";
<<<<<<< HEAD
  version = "0.8.10";
=======
  version = "0.8.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchCrate {
    pname = "refinery_cli";
    inherit version;
<<<<<<< HEAD
    sha256 = "sha256-6nb/RduzoTK5UtdzYBLdKkYTUrV9A1w1ZePqr3cO534=";
  };

  cargoHash = "sha256-rdxcWsLwhWuqGE5Z698NULg6Y2nkLqiIqEpBpceflk0=";
=======
    sha256 = "sha256-KNidO4HO4fcGXWJxFYsat2duZTzUA8XFcaK+Qzb1HFI=";
  };

  cargoHash = "sha256-nYqOGSFQ4GdUdLkZ2Xtx+bRj2sX6joxKjNqm9CloODU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Run migrations for the Refinery ORM for Rust via the CLI";
    homepage = "https://github.com/rust-db/refinery";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
