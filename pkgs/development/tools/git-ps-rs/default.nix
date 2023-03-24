{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, pkg-config
, libgpg-error
, gpgme
, dbus
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-ps-rs";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "uptech";
    repo = "git-ps-rs";
    rev = version;
    hash = "sha256-pWad/OCSoszdEQb6Mb6fD4vsZRagbYa3TKft4IyGg94=";
  };

  cargoHash = "sha256-MoWb6slvcTlLYbUg/5xBuOYT40C9SQeHIJKdBdhqics=";

  nativeBuildInputs = [
    pkg-config
    gpgme # gpgme runs a small script at build time so has to go here
  ];

  buildInputs = [ openssl dbus libgpg-error ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Tool for working with a stack of patches";
    homepage = "https://git-ps.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ alizter ];
  };
}
