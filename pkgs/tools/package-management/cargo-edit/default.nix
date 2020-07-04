{ stdenv, lib, darwin
, rustPlatform, fetchFromGitHub
, openssl, pkg-config, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    sha256 = "19jnvsbddn52ibjv48jyfss25gg9mmvxzfhbr7s7bqyf3bq68jbm";
  };

  cargoSha256 = "0b06jsilj87rnr1qlarn29hnz0i9p455fdxg6nf6r2fli2xpv1f0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  doCheck = false; # integration tests depend on changing cargo config

  meta = with lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = "https://github.com/killercup/cargo-edit";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gerschtli jb55 filalex77 killercup ];
    platforms = platforms.all;
  };
}
