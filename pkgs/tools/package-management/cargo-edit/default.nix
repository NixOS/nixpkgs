{ stdenv, lib, darwin
, rustPlatform, fetchFromGitHub
, openssl, pkg-config, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y0sq0kll6bg0qrfdyas8rcx5dj50j9f05qx244kv7vqxp2q25jq";
  };

  cargoSha256 = "0prd53p20cha2y2qp8dmq0ywd32f6jm8mszdkbi4x606dj9bcgbl";

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
