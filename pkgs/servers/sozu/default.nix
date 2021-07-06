{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "sozu";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = pname;
    rev = version;
    sha256 = "sha256-oZ078U+Ly5CKk+XjjJ9TDAiYN+2CHng2kWgRThNo2XE=";
  };

  cargoSha256 = "sha256-6UYD0VNvmver5/gkYUCyjbX4ZcxgbMFcqZ/WjypnylM=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Open Source HTTP Reverse Proxy built in Rust for Immutable Infrastructures";
    homepage = "https://www.sozu.io";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Br1ght0ne netcrns ];
  };
}
