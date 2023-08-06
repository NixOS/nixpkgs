{ lib
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "trust-dns";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "bluejekyll";
    repo = "trust-dns";
    rev = "v${version}";
    sha256 = "sha256-YjwzU/mYKiHL2xB/oczkP/4i5XYIvSNyqDLmmrRQPhM=";
  };
  cargoHash = "sha256-uAmszVOlRttmn6b3Rv2Y5ZuP3qBIVjIFJ42BJro+K8s=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # tests expect internet connectivity to query real nameservers like 8.8.8.8
  doCheck = false;

  meta = with lib; {
    description = "A Rust based DNS client, server, and resolver";
    homepage = "https://trust-dns.org/";
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
    license = with licenses; [ asl20 mit ];
  };
}
