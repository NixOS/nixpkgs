{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, libiconv, curl, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Cd0QWFeAAHSkeCVQvb+Fsg5nBoutV1k1kQpMkWpci2E=";
  };

  cargoSha256 = "sha256-VngJMDVKIV8+ODHia2U2gKKPKskyKiuKhSnO6NJsJHI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
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
