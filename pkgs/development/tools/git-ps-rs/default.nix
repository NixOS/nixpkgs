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
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "uptech";
    repo = "git-ps-rs";
    rev = version;
    hash = "sha256-4wSm3H+98ZJZ+fZdLYshPKafRkPq98Pv3Lwh9o0be6U=";
  };

  cargoHash = "sha256-1p46xvo7abMPlVP8BeQ1j/8QQpK3kCgbTL3cdidfq04=";

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
