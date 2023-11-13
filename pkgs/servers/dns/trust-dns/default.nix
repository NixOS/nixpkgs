{ lib
, fetchFromGitHub
, openssl
, pkg-config
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "trust-dns";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "bluejekyll";
    repo = "trust-dns";
    rev = "v${version}";
    sha256 = "sha256-CfFEhZEk1Z7VG0n8EvyQwHvZIOEES5GKpm5tMeqhRVY=";
  };
  cargoHash = "sha256-jmow/jtdbuKFovXWA5xbgM67iJmkwP35hiOivIJ5JdM=";

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
