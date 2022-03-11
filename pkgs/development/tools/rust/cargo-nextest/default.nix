{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    sha256 = "sha256-1s1N126S51kg7aOgAb8oMts1zJcO6QRn1fwbQf6ZaJ8=";
  };

  cargoSha256 = "sha256-JxZyl5Hti3Hh33e7H/pXhM6WkU0kDDml0naBPYzvNy4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    libiconv
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Test runner for Rust";
    homepage = "https://nexte.st";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ fintohaps ];
  };
}
