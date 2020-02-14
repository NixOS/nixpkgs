{ stdenv, lib, darwin
, rustPlatform, fetchFromGitHub
, openssl, pkg-config, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    sha256 = "16gpljbzk6cibry9ssnl22xbcsx2cr57mrs3x3n6cfmldbp6bhbr";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1cjpbfgbqzlfs5hck2j3d2v719fwandpnc7bdk4243j7j0k1ng9q";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = https://github.com/killercup/cargo-edit;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gerschtli jb55 filalex77 ];
    platforms = platforms.all;
  };
}
