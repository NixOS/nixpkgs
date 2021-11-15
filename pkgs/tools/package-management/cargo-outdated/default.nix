{ lib, stdenv, fetchCrate, rustPlatform, pkg-config, openssl, libiconv, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.9.18";

  src = fetchCrate {
    inherit pname version;
    sha256 = "19r4nv28iq4cmzs5j127qgvdf7y3pfmgjp6jzzbb8b5xj7w06jhl";
  };

  cargoSha256 = "1rf3sxprra9s76iip2xf82kclgs83fhnlx9ykl9hhn2y0z8r3342";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
    libiconv
    curl
  ];

  meta = with lib; {
    description = "A cargo subcommand for displaying when Rust dependencies are out of date";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ sondr3 ivan ];
  };
}
