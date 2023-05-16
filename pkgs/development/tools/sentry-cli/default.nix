{ rustPlatform
, fetchFromGitHub
, lib
, openssl
, pkg-config
, stdenv
, Security
, SystemConfiguration
}:
rustPlatform.buildRustPackage rec {
  pname = "sentry-cli";
<<<<<<< HEAD
  version = "2.20.7";
=======
  version = "2.17.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-cli";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-H1WRjNMYcWqc9Y8H7agzA7uMhvlA4DXpJOUpbUG+xxU=";
=======
    sha256 = "sha256-7qBw0MT1FM1rAbOEtVuf/XEBY8yosRWsnGwVbqpc3QQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  doCheck = false;

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];
  nativeBuildInputs = [ pkg-config ];

<<<<<<< HEAD
  cargoHash = "sha256-WLnvyQQ51dIsD5g3FjHJhA+EqB1UEHghwxI/TVYwNdo=";
=======
  cargoHash = "sha256-LAasV0rY4jgoC+soBshECUXvXYIe5zQZmnKtBONAD6g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://docs.sentry.io/cli/";
    license = licenses.bsd3;
    description = "A command line utility to work with Sentry";
    changelog = "https://github.com/getsentry/sentry-cli/raw/${version}/CHANGELOG.md";
<<<<<<< HEAD
    maintainers = with maintainers; [ rizary loewenheim ];
=======
    maintainers = with maintainers; [ rizary ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
