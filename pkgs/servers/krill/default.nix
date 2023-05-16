{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "krill";
<<<<<<< HEAD
  version = "0.13.1";
=======
  version = "0.12.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-UwvSwV1EHcEsF+IScdDiuuU56sXojEWGObzPKrLvlEQ=";
  };

  cargoHash = "sha256-ts0yr1BY/StEmklUB29blR4K6RfHbH5WzIP2Zs2sVR4=";
=======
    hash = "sha256-N12Uc2Dh0JFCEOzFvU5YzPeupcaOetW6ehRuAYOYJn0=";
  };

  cargoHash = "sha256-pcoGFXano34Sc+iVqJfrUo+wWASpAA1gslCHfVcEoJ4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin Security;
  nativeBuildInputs = [ pkg-config ];

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "RPKI Certificate Authority and Publication Server written in Rust";
    longDescription = ''
      Krill is a free, open source RPKI Certificate Authority that lets you run
      delegated RPKI under one or multiple Regional Internet Registries (RIRs).
      Through its built-in publication server, Krill can publish Route Origin
      Authorisations (ROAs) on your own servers or with a third party.
    '';
    homepage = "https://github.com/NLnetLabs/krill";
    changelog = "https://github.com/NLnetLabs/krill/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ steamwalker ];
  };
}
