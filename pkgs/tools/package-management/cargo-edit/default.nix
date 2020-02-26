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

  cargoSha256 = "1zwkar914zyghky09lgk0s374m5d6yccn0m15bqlgxxyymg4b59y";

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
